# encoding: utf-8

module ApplicationHelper

  def wrap_descs(descriptions, title = "")
    returnstrings = title << "\n\n\n"
    descriptions.each do |desc|
      returnstrings << desc
      returnstrings  << "\n\n"
    end
    
    returnstrings << iine_desc
    returnstrings << tux_url
    return returnstrings
  end

  def iine_desc
    return "\n\n\n----いい話だと思ったらシェアをお願いします m(_ _)m ----\n"
  end

   def tux_url
    return "\nhttp://tuxurecords.tumblr.com/\n"
  end

end
