class GithubController < ApplicationController
  before_action :signed_in?

  CLIENT_ID    = ENV['GITHUB_CLIENT_ID']
  CLIENT_SECRET = ENV['GITHUB_CLIENT_SECRET']

  def index
    #response.headers['Content-Disposition'] = 'attachment;'
  end

  def autofolio
    # Octokit
    token = @current_user.token
    oclient = Octokit::Client.new(:access_token => token)

    @data = []
    repos = oclient.repositories(oclient.user.login)
    repos.each do |repo|
      h = {}
      h.store("name", repo.name)
      h.store("lang", repo.language)
      h.store("url", repo.html_url)
      h.store("description", repo.description)
      h.store("star", repo.stargazers_count)
      h.store("user", repo.owner.login)
      h.store("avatar", repo.owner.avatar_url)
      @data.push(h)
    end
  end

  def download
    response.headers['Content-Disposition'] = 'attachment; filename=autofolio.html'
    # Octokit
    token = @current_user.token
    oclient = Octokit::Client.new(:access_token => token)

    @data = []
    repos = oclient.repositories(oclient.user.login)
    repos.each do |repo|
      h = {}
      h.store("name", repo.name)
      h.store("lang", repo.language)
      h.store("url", repo.html_url)
      h.store("description", repo.description)
      h.store("star", repo.stargazers_count)
      h.store("user", repo.owner.login)
      h.store("avatar", repo.owner.avatar_url)
      @data.push(h)
    end
    
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
