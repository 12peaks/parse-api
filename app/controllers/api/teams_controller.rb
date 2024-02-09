class Api::TeamsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def team_users
    user = current_user || api_user
    team = user.current_team
    render json: team.users.as_json(only: [:id, :name, :github_image])
  end
  
  private
end