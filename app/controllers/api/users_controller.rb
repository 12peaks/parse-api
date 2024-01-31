class Api::UsersController < ApplicationController
  def client_user
    if current_user
      render json: current_user
    else
      render json: { error: "Not logged in" }, status: :unauthorized
    end
  end
end