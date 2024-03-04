class Users::InvitationsController < Devise::InvitationsController
  include ApiAuthentication
  before_action :set_current_user
  skip_forgery_protection

  def create
    super do |resource|
      if resource.errors.empty?
        render json: { success: true, message: 'Invitation sent' }, status: :ok and return
      else
        render json: { error: resource.errors.full_messages }, status: :bad_request and return
      end
    end
  end

  private

  def invite_resource
    super do |user|
      user.skip_confirmation!
      user.current_team = current_user.current_team
      user.teams << current_user.current_team
      user.save
    end
  end

  def authenticate_inviter!
    return api_user if api_request?

    super
  end

  def set_current_user
    return unless api_request?

    @current_user = api_user
  end
end

