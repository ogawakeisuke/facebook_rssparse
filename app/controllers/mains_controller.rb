# coding: utf-8

class MainsController < ApplicationController
  require 'rss'
  require 'kconv'

  def index
    uri = "http://www.facebook.com/feeds/page.php?format=rss20&id=238534679512353"
    rss = RSS::Parser.parse(uri, true)
    @descs = rss.channel.items.collect {|item| item.description.split(/(<br\/>)|(<br\s\/>)/).reject {|arr| arr =~ /<br\/>|<br\s\/>/}.delete_if{|item|item.blank?} }

    #
    # ここからスクランブル
    #
    @title_collections = @descs.collect { |desc| desc[0] }.flatten
    @desc_collections = @descs.collect { |desc| desc.drop(1).delete_if {|description| description =~ /<.*.>|＿.*.＿/} }.flatten
    @img_tag_collections = @descs.collect {|desc| desc.select {|description| description =~ /<.*.>/ } }.flatten
    # @img_url = img_tag_collections.sample =~ /src\=\"/
    # logs @img_url
  end

  def post
    redirect_to root_path, :notice => "tokenが取得されていない" and return unless session[:token] 

    access_token = open("https://graph.facebook.com/oauth/access_token?client_id=#{FB_APP_ID}&client_secret=#{FB_APP_SECRET}&grant_type=client_credentials"){|f| f.read}
    
    @user_graph = Koala::Facebook::API.new(access_token)
    accounts = @user_graph.get_connections('me', 'accounts')
    page = accounts.find{|a| a['id'] == "#{FB_PAGE_ID}"}
    @page_graph = Koala::Facebook::API.new(page['access_token'])

    @page_graph.put_object(page['id'], 'feed', :message => '投稿するメッセージ')
  end

end
