class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, :lockable, :trackable, :omniauthable,
         omniauth_providers: %i[github]

  def self.from_omniauth(auth, referrer = nil)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.names

      if auth.provider == "github"
        user.github_image = auth.info.image
        user.github_username = auth.info.nickname
        user.x_username = auth.extra&.raw_info&.twitter_username
      end

      user.skip_confirmation!
    end
  end
end
