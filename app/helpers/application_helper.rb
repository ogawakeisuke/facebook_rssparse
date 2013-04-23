# encoding: utf-8

module ApplicationHelper

  def wrap_descs(descriptions)
    returnstrings = ""
    descriptions.each do |desc|
      returnstrings << desc
      returnstrings  << "\n\n"
    end
    return returnstrings
  end

  def iine_desc
    return "\n\n\n--------いい話だと思ったらシェアをお願いします--------"
  end

end
