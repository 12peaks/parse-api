class Api::GroupsController < ApplicationController
  include ApiAuthentication
  skip_forgery_protection
  #before_action :authenticate_user!

  def index
    user = current_user || api_user
    groups = user.current_team.groups
    render json: groups.as_json(methods: [:avatar_url, :cover_image_url])
  end

  def show
    user = current_user || api_user
    group = user.current_team.groups.find_by(id: params[:id])
    if group
      render json: group.as_json(methods: [:avatar_url, :cover_image_url])
    else
      render json: { error: "Group not found in your current team" }, status: :not_found
    end
  end
  
  def create
    user = current_user || api_user
    group = user.current_team.groups.new(group_params)
    if group.save
      render json: group, methods: [:avatar_url, :cover_image_url]
    else
      render json: { error: group.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    render json: { success: true, message: "Group deleted" }
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :is_private, :is_visible, :avatar, :cover_image)
  end
end
