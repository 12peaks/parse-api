class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  def client_user
    if current_user
      render json: current_user
    else
      render json: { error: "Not logged in" }, status: :unauthorized
    end
  end

  private
  def authenticate_user!
    unless user_signed_in?
      render json: { error: "Not logged in" }, status: :unauthorized
    end
  end
end