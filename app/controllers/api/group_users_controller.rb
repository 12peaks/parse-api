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

  def destroy
    group_id = params[:group_id]
    user_id = params[:user_id]
    group_user = GroupUser.find_by(group_id: group_id, user_id: user_id)
    if group_user
      group_user.destroy
      render json: { success: true, message: "Group user deleted" }
    else
      render json: { error: "Group user not found" }, status: :not_found
    end
  end

  def join
    user = current_user || api_user
    group = Group.find(params[:group_id])
    group_user = GroupUser.new(group: group, user: user)
    if group_user.save
      render json: group_user
    else
      render json: { error: group_user.errors.full_messages }, status: :bad_request
    end
  end

  def leave
    user = current_user || api_user
    group_user = GroupUser.find_by(group_id: params[:group_id], user_id: user.id)
    if group_user
      group_user.destroy
      render json: { success: true, message: "Group user deleted" }
    else
      render json: { error: "Group user not found" }, status: :not_found
    end
  end

  private

  def group_user_params
    params.require(:group_user).permit(:group_id, :user_id)
  end
end