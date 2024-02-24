class Api::PollVotesController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def create
    user = current_user || api_user
    poll_option = PollOption.find(params[:poll_option_id])
    poll_vote = PollVote.new(poll_option: poll_option, user: user)
    if poll_vote.save
      render json: poll_vote
    else
      render json: { error: poll_vote.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    user = current_user || api_user
    poll_option = PollOption.find(params[:poll_option_id])
    poll_vote = PollVote.find_by(poll_option: poll_option, user: user)
    if poll_vote
      poll_vote.destroy
      render json: { success: true, message: "Poll vote deleted" }
    else
      render json: { error: "Poll vote not found" }, status: :not_found
    end
  end
end
