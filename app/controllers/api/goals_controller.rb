class Api::GoalsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    user = current_user || api_user
    goals = user.current_team.goals
    render json: goals.as_json(include: [
      { user: { only: [:id, :name], methods: [:avatar_image_url] } },
      { goal_updates: { include: { user: { only: [:id, :name], methods: [:avatar_image_url] } }, order: 'created_at ASC' } },
      { goal_collaborators: { include: { user: { only: [:id, :name], methods: [:avatar_image_url] } } } }
    ])
  end

  def show
    user = current_user || api_user
    goal = user.current_team.goals.find_by(id: params[:id])
    if goal
      render json: goal.as_json(include: [
        { user: { only: [:id, :name], methods: [:avatar_image_url] } },
        { goal_updates: { include: { user: { only: [:id, :name], methods: [:avatar_image_url] } }, order: 'created_at ASC' } },
        { goal_collaborators: { include: { user: { only: [:id, :name], methods: [:avatar_image_url] } } } }
      ])
    else
      render json: { error: "Goal not found in your current team" }, status: :not_found
    end
  end

  def create
    user = current_user || api_user
    goal = user.current_team.goals.new(goal_params)
    goal.user = user
    if goal.save
      render json: goal.as_json(include: [
        { user: { only: [:id, :name], methods: [:avatar_image_url] } },
        { goal_updates: { only: [:id, :note, :value, :status, :created_at, :updated_at] } },
        { goal_collaborators: { include: { user: { only: [:id, :name], methods: [:avatar_image_url] } } } }
      ])
    else
      puts goal.errors.full_messages
      render json: { error: goal.errors.full_messages }, status: :bad_request
    end
  end

  def update
    user = current_user || api_user
    goal = user.current_team.goals.find_by(id: params[:id])
    if goal
      if goal.update(goal_params)
        render json: goal.as_json(include: [
          { user: { only: [:id, :name], methods: [:avatar_image_url] } },
          { goal_updates: { only: [:id, :note, :value, :status, :created_at, :updated_at] } },
          { goal_collaborators: { include: { user: { only: [:id, :name], methods: [:avatar_image_url] } } } }
        ])
      else
        render json: { error: goal.errors.full_messages }, status: :bad_request
      end
    else
      render json: { error: "Goal not found in your current team" }, status: :not_found
    end
  end

  def destroy
    user = current_user || api_user
    goal = user.current_team.goals.find_by(id: params[:id])
    if goal
      goal.destroy
      render json: { success: true, message: "Goal deleted" }
    else
      render json: { error: "Goal not found in your current team" }, status: :not_found
    end
  end
  
  private

  def goal_params
    params.require(:goal).permit(:name, :description, :user, :team, :format, :start_date, :end_date, :initial_value, :target_value, goal_collaborators: [])
  end
end
