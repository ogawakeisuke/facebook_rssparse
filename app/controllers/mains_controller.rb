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
    
    #
    # - deprecated -
    # tag_collection = @descs.collect {|desc| desc.select {|description| description =~ /<.*.>/ } }.flatten
    # @img_tag_collection = img_collect(tag_collection)
  end

  def post
    redirect_to root_path, :notice => "tokenが取得されていない" and return unless session[:token] 

    image = params[:images].read || "http://www.universe-s.com/img/news/2004/0520_01.jpg"
    @iine_desc = self.class.helpers.iine_desc

    access_token = session[:token]
    
    @user_graph = Koala::Facebook::API.new(access_token)

    if @user_graph.put_picture(image, {:message => "#{params[:title]}\n\n#{params[:desc]}#{@iine_desc}"}) 
      reset_session
      redirect_to root_path, :notice => "Sigined out!"
    end
  end

end
