class Users::InvitationsController < Devise::InvitationsController
  include ApiAuthentication
  before_action :set_current_user
  skip_forgery_protection

  private

  def invite_resource
    super { |user|
      user.skip_confirmation!
      user.current_team = current_user.current_team
      user.teams << current_user.current_team
      user.save
    }
  end

  def authenticate_inviter!
    if api_request?
      return api_user
    end
    super
  end

  def set_current_user
    if api_request?
      @current_user = api_user
    end
  end
end