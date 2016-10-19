class User < ApplicationRecord

  def self.create_auth(auth)
    create! do |user|
      user.provider    = auth['provider']
      user.uid         = auth['uid']
      user.screen_name = auth['info']['nickname']
      user.name        = auth['info']['name']
    end
  end

end
