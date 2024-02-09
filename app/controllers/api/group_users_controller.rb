class Api::GroupUsersController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def create
    group_user = GroupUser.new(group_user_params)
    if group_user.save
      render json: group_user
    else
      render json: { error: group_user.errors.full_messages }, status: :bad_request
    end
  end

  private

  def group_user_params
    params.require(:group_user).permit(:group_id, :user_id)
  end
end