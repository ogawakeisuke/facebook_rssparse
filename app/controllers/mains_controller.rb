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
    @title_collection = @descs.collect { |desc| desc[0] }.flatten.sample
    @desc_collections = @descs.collect { |desc| desc.drop(1).delete_if {|description| description =~ /<.*.>|＿.*.＿/} }.flatten.sample(15)
    tag_collection = @descs.collect {|desc| desc.select {|description| description =~ /<.*.>/ } }.flatten

    @img_tag_collection = img_collect(tag_collection)
    logger.debug "---------@img_tag_collection#{@img_tag_collection}"

    # @img_url = img_tag_collections.sample =~ /src\=\"/
    # logs @img_url
  end

  def post
    redirect_to root_path, :notice => "tokenが取得されていない" and return unless session[:token] 

    @iine_desc = self.class.helpers.iine_desc

    access_token = session[:token]
    
    @user_graph = Koala::Facebook::API.new(access_token)
    accounts = @user_graph.get_connections('me', 'accounts')
    page = accounts.find{|a| a['id'] == "#{FB_PAGE_ID}"}
    @page_graph = Koala::Facebook::API.new(page['access_token'])

     if @page_graph.put_object(page['id'], 'feed', :message => "#{params[:title]}\n\n#{params[:desc]}#{@iine_desc}", :picture => params[:img]) 
      reset_session
      redirect_to root_path, :notice => "Sigined out!"
    end
  end

end
