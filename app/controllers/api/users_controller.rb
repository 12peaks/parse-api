class Api::UsersController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection
  

  def client_user
    user = current_user || api_user
    if user
      render json: user.as_json(methods: [:avatar_image_url], include: { current_team: { only: [:id, :name] } })
    else
      render json: { error: "Not logged in" }, status: :unauthorized
    end
  end

  def update
    user = current_user || api_user
    if user.update(user_params)
      render json: user
    else
      render json: { error: user.errors.full_messages }, status: :bad_request
    end
  end

  def switch_team
    team_id = params[:team_id]
    
    if current_user.teams.exists?(team_id: team_id)
      current_user.update(current_team_id: team_id)
      render json: { success: true, message: "Switched team" }
    else
      render json: { error: "Team not found" }, status: :not_found
    end
  end

  def log_out
    sign_out(current_user)
    render json: { success: true, message: "Logged out" }
  end

  private
  def authenticate_user!
    unless user_signed_in?
      render json: { error: "Not logged in" }, status: :unauthorized
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end