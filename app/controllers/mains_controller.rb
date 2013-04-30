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

    # @img_url = img_tag_collections.sample =~ /src\=\"/
    # logs @img_url
    respond_to do |format|
      format.html 
      format.json { render :json => {title: @title_collection, desc: @desc_collections, img_url: @img_tag_collection } }
    end
  end

  def post
    redirect_to root_path, :notice => "tokenが取得されていない" and return unless session[:token] 

    iine_desc = self.class.helpers.iine_desc
    tux_url = self.class.helpers.tux_url

    access_token = session[:token]
    
    @user_graph = Koala::Facebook::API.new(access_token)

    if @user_graph.put_picture(params[:img], {:message => "#{params[:title]}\n\n#{params[:desc]}#{iine_desc}#{tux_url}"}) 
      reset_session
      redirect_to root_path, :notice => "Sigined out!"
    end
  end

end
