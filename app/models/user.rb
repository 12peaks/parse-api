class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, :lockable, :trackable, :omniauthable,
         omniauth_providers: %i[github google_oauth2]

  has_many :api_keys, dependent: :destroy
  has_many :posts
  has_many :comments
  has_many :reactions
  has_many :notifications
  has_many :triage_events
  has_many :triage_event_comments
  has_many :triage_timeline_events
  has_many :group_users
  has_many :groups, through: :group_users
  has_and_belongs_to_many :teams
  belongs_to :current_team, class_name: "Team", optional: true

  after_create :generate_first_api_key
  after_create :assign_default_team, unless: Proc.new { invited_to_team? || invitation_token.present? }

  def self.from_omniauth(auth, referrer = nil)
    user = User.find_by(email: auth.info.email)
    if user.present?
      user.update(provider: auth.provider, uid: auth.uid, email: auth.info.email)
      
      if auth.provider == "github"
        user.update(github_username: auth.info.nickname, x_username: auth.extra&.raw_info&.twitter_username)
      end
      user
    else
      find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]

        if auth.provider == "google_oauth2"
          user.name = auth.info.name
          user.avatar_url = auth.info.image
        end

        if auth.provider == "github"
          user.name = auth.info.name
          user.avatar_url = auth.info.image
          user.github_username = auth.info.nickname
          user.x_username = auth.extra&.raw_info&.twitter_username
        end

        user.skip_confirmation!
      end
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
    default_team = Team.find_or_create_by(name: "#{self.email}'s Team")
    self.teams << default_team
    self.current_team = default_team
  end

  def invited_to_team?
    self.current_team.present?
  end
end
