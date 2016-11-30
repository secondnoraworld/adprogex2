class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    user = User.create_auth(auth)
    session[:user_id] = user.id
    case auth['provider']
    when 'twitter'
      redirect_to twitter_path
    when 'github'
      redirect_to github_path
    else
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end
