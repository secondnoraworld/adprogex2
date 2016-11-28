class TwitterController < ApplicationController

  CONSUMER_KEY    = ENV['TWITTER_CONSUMER_KEY']
  CONSUMER_SECRET = ENV['TWITTER_CONSUMER_SECRET']

  def index
  end

  def show
    credentials = Base64.encode64("#{CONSUMER_KEY}:#{CONSUMER_SECRET}").gsub("\n", "")

    post_url    = 'https://api.twitter.com/oauth2/token'
    body        = 'grant_type=client_credentials'
    headers     = {
      "Authorization": "Basic #{credentials}",
      "Content-Type":  "application/x-www-form-urlencoded;charset=UTF-8"
    }
    r               = HTTParty.post(post_url, body: body, headers: headers)
    bearer_token    = JSON.parse(r.body)['access_token']
    api_auth_header = {"Authorization": "Bearer #{bearer_token}"}

    case params[:request]
    when 'userinfo'
      get_show_url      = "https://api.twitter.com/1.1/users/show.json?screen_name=#{current_user.screen_name}"
      userinfo_origin   = HTTParty.get(get_show_url, headers: api_auth_header).body
      @userinfo         = JSON.parse(userinfo_origin)
    when 'friends-only', 'followers-only'
      get_friends_url     = "https://api.twitter.com/1.1/friends/ids.json?screen_name=#{current_user.screen_name}"
      get_followers_url   = "https://api.twitter.com/1.1/followers/ids.json?screen_name=#{current_user.screen_name}"
      friends_origin      = HTTParty.get(get_friends_url,   headers: api_auth_header).body
      followers_origin    = HTTParty.get(get_followers_url, headers: api_auth_header).body
      @friends            = JSON.parse(friends_origin)
      @followers          = JSON.parse(followers_origin)
    end

    case params[:request]
    when 'friends-only'
      @friends_only   = @friends['ids'] - @followers['ids']
    when 'followers-only'
      @followers_only = @followers['ids'] - @friends['ids']
    end
  end

end
