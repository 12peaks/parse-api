class Api::PollsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    user = current_user || api_user
    polls = user.current_team.polls.order(created_at: :desc)
    render json: polls.as_json(include: { poll_options: { include: 
      { poll_votes: { include: { user: { only: [:id], methods: [:avatar_image_url] } } } } }, 
      user: { only: [:id, :name], methods: [:avatar_image_url] } })
  end

  def create
    user = current_user || api_user
    poll = Poll.new(poll_params)
    poll.user_id = user.id
    poll.team_id = user.current_team.id
    
    if poll.save
      render json: poll.as_json(include: { poll_options: { include: 
        { poll_votes: { include: { user: { only: [:id], methods: [:avatar_image_url] } } } } }, 
        user: { only: [:id, :name], methods: [:avatar_image_url] } })
    else
      render json: { error: poll.errors.full_messages }, status: :bad_request
    end
  end

  def show
    user = current_user || api_user
    poll = user.current_team.polls.find_by(id: params[:id])
    if poll
      render json: poll.as_json(include: { poll_options: { include: 
        { poll_votes: { include: { user: { only: [:id], methods: [:avatar_image_url] } } } } }, 
        user: { only: [:id, :name], methods: [:avatar_image_url] } })
    else
      render json: { error: "Poll not found in your current team" }, status: :not_found
    end
  end

  def update
    user = current_user || api_user
    poll = user.current_team.polls.find_by(id: params[:id])
    if poll
      if poll.update(poll_params)
        render json: poll.as_json(include: { poll_options: { include: 
          { poll_votes: { include: { user: { only: [:id], methods: [:avatar_image_url] } } } } }, 
          user: { only: [:id, :name], methods: [:avatar_image_url] } })
      else
        render json: { error: poll.errors.full_messages }, status: :bad_request
      end
    else
      render json: { error: "Poll not found in your current team" }, status: :not_found
    end
  end

  def destroy
    user = current_user || api_user
    poll = user.current_team.polls.find_by(id: params[:id])
    if poll
      poll.destroy
      render json: { success: true, message: "Poll deleted" }
    else
      render json: { error: "Poll not found in your current team" }, status: :not_found
    end
  end

  private

  def poll_params
    params.require(:poll).permit(:content, :user_id, :team_id, :group_id, poll_options_attributes: [:id, :text, :_destroy])
  end
end
