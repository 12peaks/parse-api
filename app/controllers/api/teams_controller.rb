class Api::TeamsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def team_user
    user = current_user || api_user
    team = user.current_team
    team_user = team.users.find_by(id: params[:user_id])
    if team_user
      render json: team_user.as_json(only: [:id, :name, :email, :avatar_url, :created_at, :updated_at, :invitation_created_at, :last_sign_in_at])
    else
      render json: { error: "User not found in your current team" }, status: :not_found
    end
  end


  def team_users
    user = current_user || api_user
    team = user.current_team
    render json: team.users.as_json(only: [:id, :name, :email, :avatar_url, :created_at, :updated_at, :invitation_created_at, :last_sign_in_at])
  end

  private
end