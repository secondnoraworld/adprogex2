# Advanced Programming 2

This repository is for a team project of Advanced Programming 2. Advanced Programming 2, the class of the university, lets us develop freely and work together. This project is basically managed with two developers.

We plan to develop the Twitter statistical analysis and the GitHub portfolio generator with GitHub Pages, using OAuth and API.

## Version Dependencies

All codes of this repository work successfully under the following environments.

* Ruby on Rails 5.0.0.1
* Ruby 2.3.1

In terms of the RubyGems dependencies, see [Gemfile](https://github.com/secondnoraworld/adprogex2/blob/master/Gemfile).

## Environment Variables

The environment variables are under the control of `.env` file. Create `.env` file under Rails application directory and append the environment variables below.

```Ruby
TWITTER_CONSUMER_KEY='YOUR_TWITTER_CONSUMER_KEY_HERE'
TWITTER_CONSUMER_SECRET='YOUR_TWITTER_CONSUMER_SECRET_HERE'
TWITTER_ACCESS_TOKEN="YOUR_TWITTER_ACCESS_TOKEN"
TWITTER_ACCESS_TOKEN_SECRET="YOUR_TWITTER_ACCESS_TOKEN_SECRET"
GITHUB_CLIENT_ID='YOUR_GITHUB_CLIENT_ID_HERE'
GITHUB_CLIENT_SECRET='YOUR_GITHUB_CLIENT_SECRET_HERE'
```

Each API key is available at the following page.

* [Twitter Application Management](https://apps.twitter.com)
* [Developer applications](https://github.com/settings/developers)


## License

All codes of this repository are available under the MIT license. See the [LICENSE](https://github.com/secondnoraworld/adprogex2/blob/master/LICENSE) for more infomation.
