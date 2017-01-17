class TwitterController < ApplicationController
  before_action :signed_in?

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
      # TODO: fix: sometime an error occurred: undefined method `-' for nil:NilClass
      # perhaps: Twitter API rate limit exceeded
      @friends_or_followers_only = @friends['ids'] - @followers['ids']
      @btn_title  = 'フォロー解除'
      @btn_action = 'unfollow'
      @friends_or_followers_only_desc = 'あなたがフォローしていて、相手がフォローしていないユーザ'
    when 'followers-only'
      # TODO: fix: sometime an error occurred: undefined method `-' for nil:NilClass
      # perhaps: Twitter API rate limit exceeded
      @friends_or_followers_only = @followers['ids'] - @friends['ids']
      @btn_title  = 'フォロー'
      @btn_action = 'follow'
      @friends_or_followers_only_desc = '相手がフォローしていて、あなたがフォローしていないユーザ'
    end

    case params[:request]
    when 'friends-only', 'followers-only'
      @friends_or_followers_only_screen_name = []
      @friends_userinfo_origin = []
      @friends_userinfo = []
      post_friends_or_followers_userinfo_url = "https://api.twitter.com/1.1/users/lookup.json?user_id="
      count = 0
      while count < @friends_or_followers_only.count do
        if @friends_or_followers_only.count - count >= 100
          100.times do |i|
            post_friends_or_followers_userinfo_url += @friends_or_followers_only[count].to_s + ','
            count += 1
          end
        else
          (@friends_or_followers_only.count - count).times do |i|
            post_friends_or_followers_userinfo_url += @friends_or_followers_only[count].to_s + ','
            count += 1
          end
        end
        # delete last comma: 'a,b,c,d,e,' => 'a,b,c,d,e'
        post_friends_or_followers_userinfo_url.chop!
        @friends_userinfo_origin.push(HTTParty.post(post_friends_or_followers_userinfo_url, headers: api_auth_header).body)
        # reset lookup json request url
        post_friends_or_followers_userinfo_url = "https://api.twitter.com/1.1/users/lookup.json?user_id="
      end
      @friends_userinfo_origin.each do |friend_userinfo_origin|
        @friends_userinfo.push(JSON.parse(friend_userinfo_origin))
      end
      @friends_userinfo.flatten!
    end
  end

  def create
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    username = params[:username]
    client.follow(username)
    redirect_to '/twitter/followers-only', notice: '@' + username + 'さんをフォローしました'
  end

  def destroy
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    username = params[:username]
    client.unfollow(username)
    redirect_to '/twitter/friends-only', notice: '@' + username + 'さんをフォロー解除しました'
  end

  private
  def signed_in?
    unless current_user
      redirect_to '/auth/twitter'
    end
  end

end
