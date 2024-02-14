class Api::GroupsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    user = current_user || api_user
    if params[:joined] == 'true'
      groups = user.groups.where(team: user.current_team)
    elsif params[:slug].present?
      groups = user.current_team.groups.where(url_slug: params[:slug]).first
    else
      groups = user.current_team.groups
    end
    render json: groups.as_json(methods: [:avatar_url, :cover_image_url], 
      include: {group_users: {only: [:id, :created_at, :updated_at, :name, :email, :avatar_url]}})
  end

  def show
    user = current_user || api_user
    group = user.current_team.groups.find_by(id: params[:id])
    if group
      render json: group.as_json(methods: [:avatar_url, :cover_image_url],
        include: {group_users: {only: [:id, :created_at, :updated_at, :name, :email, :avatar_url]}})
    else
      render json: { error: "Group not found in your current team" }, status: :not_found
    end
  end
  
  def create
    user = current_user || api_user
    group = user.current_team.groups.new(group_params)
    if group.save
      group_user = GroupUser.create(group: group, user: user)
      if group_user.persisted?
        render json: group, methods: [:avatar_url, :cover_image_url]
      else
        render json: { error: group_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: group.errors.full_messages }, status: :bad_request
    end
  end

  def update
    user = current_user || api_user
    group = user.current_team.groups.find_by(id: params[:id])
    if group
      if group.update(group_params)
        render json: group, methods: [:avatar_url, :cover_image_url]
      else
        render json: { error: group.errors.full_messages }, status: :bad_request
      end
    else
      render json: { error: "Group not found in your current team" }, status: :not_found
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
