class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, :lockable, :trackable, :omniauthable,
         omniauth_providers: %i[github]

  has_many :api_keys, dependent: :destroy
  has_many :posts
  has_many :group_users
  has_many :groups, through: :group_users
  has_and_belongs_to_many :teams
  belongs_to :current_team, class_name: "Team", optional: true

  after_create :generate_first_api_key
  after_create :assign_default_team, unless: :invited_to_team?

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

  def key
    self.api_keys.first.key
  end

  private

  def generate_first_api_key
    self.api_keys.create
  end

  def assign_default_team
    default_team = Team.find_or_create_by(name: "#{user.email}'s Team")
    self.teams << default_team
  end

  def invited_to_team?
    false
  end
end
