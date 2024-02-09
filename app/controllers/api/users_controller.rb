class Api::UsersController < ApplicationController
  include ApiAuthentication
  skip_forgery_protection
  before_action :authenticate_user!
  

  def client_user
    if current_user
      render json: current_user
    else
      render json: { error: "Not logged in" }, status: :unauthorized
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
end