class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  

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