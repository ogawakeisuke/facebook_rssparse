# coding: utf-8

class ApplicationController < ActionController::Base
  # http_basic_authenticate_with :name => "iihanashi", :password => "pass"
  protect_from_forgery

  def logs(object)
    logger.debug"-----------------#{object.to_yaml}"
  end

  def return_tag_between(unporsed, start, termi)
    unporsed =~ /#{start}(.*?)#{termi}/
    return $1
  end

  def img_collect(tag_collections)
    arr = []
    tag_collections.each do |tag|
      arr << return_tag_between(tag,'src="','"')
    end
    return arr.compact.sample.gsub("_s.","_n.")
  end

  #
  # 正規表現に代入用
  #
  def ignore_words
    [
      "南蔵院住職", "山坂大輔", "大畑誠也", " 『致知』", "「盛衰の原理」", "(c)Tomo.Yun", "ダイヤモンド社", "林覚乗和尚", 
      "岡むら浪漫", "イ・チョルファン", "以下のサイト様より", "www.amazon.co.jp", "孫正義語録制作委員会", "フォレスト出版"
    ].join("|")
  end

end
