class Api::GoalUpdatesController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def create
    user = current_user || api_user
    goal = user.current_team.goals.find(params[:goal_id])
    goal_update = goal.goal_updates.new(goal_update_params)
    if goal_update.save
      render json: goal_update
    else
      render json: { error: goal_update.errors.full_messages }, status: :bad_request
    end
  end

  def update
    user = current_user || api_user
    goal = user.current_team.goals.find(params[:goal_id])
    goal_update = goal.goal_updates.find(params[:id])
    if goal_update.update(goal_update_params)
      render json: goal_update
    else
      render json: { error: goal_update.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    user = current_user || api_user
    goal = user.current_team.goals.find(params[:goal_id])
    goal_update = goal.goal_updates.find(params[:id])
    goal_update.destroy
    render json: { success: true, message: "Goal update deleted" }
  end

  private

  def goal_update_params
    params.require(:goal_update).permit(:note, :status, :value, :user, :goal)
  end
end
