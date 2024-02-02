class Api::UsersController < ApplicationController
  skip_forgery_protection
  before_action :authenticate_user!
  

  def client_user
    if current_user
      render json: current_user
    else
      render json: { error: "Not logged in" }, status: :unauthorized
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