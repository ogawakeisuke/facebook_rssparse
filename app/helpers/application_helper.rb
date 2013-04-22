module ApplicationHelper

  def wrap_descs(descriptions)
    returnstrings = []
    descriptions.each do |desc|
      returnstrings << '<center>'
      returnstrings << desc
      returnstrings << '</center>'
    end
    return returnstrings.join(',')
  end

end
