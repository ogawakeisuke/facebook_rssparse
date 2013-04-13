class ApplicationController < ActionController::Base
  protect_from_forgery

  def logs(object)
    logger.debug"-----------------#{object.to_yaml}"
  end
end
