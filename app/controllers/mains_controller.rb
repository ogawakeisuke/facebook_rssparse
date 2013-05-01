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

  #
  # facebookからのコールバック先
  # ここで「投稿ありがとうございました」といっておきながらサラッとajaxでpostさせるための窓口
  #
  def thanks
    redirect_to root_path, :notice => "tokenが取得されていない" and return unless session[:token] 
    
    @img = session[:img]
    @desc = session[:desc]
    
    session[:img] = nil
    session[:desc] = nil
    
  end

  #
  # そうとう悪手
  # facebookに投稿を押してここをajaxpost データをセッションに格納する、そのあとjsでリダイレクト
  #
  def create_data_to_session
    session[:img] = params[:img]
    session[:desc] = params[:desc]
    render :json => :ok
  end

   def post
    access_token = session[:token]
 
    @user_graph = Koala::Facebook::API.new(access_token)

    if @user_graph.put_picture(params[:img], { :message => params[:desc] } ) 
      reset_session
      render :json => :ok and return
      # redirect_to root_path, :notice => "Sigined out!"
    else
      reset_session
      render :json => {:result => "Failed to save. Plase try again." }, :status => 422 and return
    end
  end


end
