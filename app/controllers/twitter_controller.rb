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

    get_url         = "https://api.twitter.com/1.1/users/show.json?screen_name=#{current_user.screen_name}"
    api_auth_header = {"Authorization": "Bearer #{bearer_token}"}
    userinfo_origin = HTTParty.get(get_url, headers: api_auth_header).body
    @userinfo       = JSON.parse(userinfo_origin)
  end

end
