class MainsController < ApplicationController
  require 'rss'
  require 'kconv'

  def index
    uri = "http://www.facebook.com/feeds/page.php?format=rss20&id=238534679512353"
    rss = RSS::Parser.parse(uri, true)
    @descs = rss.channel.items.collect {|item| item.description.split(/(<br\/>)|(<br\s\/>)/).reject {|arr| arr =~ /<br\/>|<br\s\/>/}.delete_if{|item|item.blank?} }
    # descs.each do |description|
    #   @descs = description.delete_if{|item|item.blank?}
    #   logger.debug(description.delete_if{|item|item.blank?})
    # end
  end
end
