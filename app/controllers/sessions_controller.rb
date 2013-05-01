class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    # user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:token] = auth.credentials.token
    redirect_to thanks_path, :notice => "Signed in!"
  end

  def destroy
    reset_session
    redirect_to root_path, :notice => "Sigined out!"
  end
end