class GithubController < ApplicationController
  before_action :signed_in?

  CLIENT_ID    = ENV['GITHUB_CLIENT_ID']
  CLIENT_SECRET = ENV['GITHUB_CLIENT_SECRET']

  def index
    # Octokit
    token = @current_user.token
    oclient = Octokit::Client.new(:access_token => token)

  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private
  def signed_in?
    unless current_user
      redirect_to '/auth/github'
    end
  end

end
