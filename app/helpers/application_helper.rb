module ApplicationHelper

  def wrap_descs(descriptions)
    returnstrings = ""
    descriptions.each do |desc|
      returnstrings << desc
      returnstrings  << "\n\n"
    end
    return returnstrings
  end

end
