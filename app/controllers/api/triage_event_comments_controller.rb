class Api::TriageEventCommentsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def create
    user = current_user || api_user
    triage_event_comment = TriageEventComment.new(triage_event_comment_params)
    triage_event_comment.user = user

    if triage_event_comment.save
      render json: triage_event_comment
    else
      render json: { error: triage_event_comment.errors.full_messages }, status: :bad_request
    end
  end

  def update
    user = current_user || api_user
    triage_event_comment = user.triage_event_comments.find_by(id: params[:id])
    if triage_event_comment
      if triage_event_comment.update(triage_event_comment_params)
        render json: triage_event_comment
      else
        render json: { error: triage_event_comment.errors.full_messages }, status: :bad_request
      end
    else
      render json: { error: "Triage event comment not found" }, status: :not_found
    end
  end

  def destroy
    user = current_user || api_user
    triage_event_comment = user.triage_event_comments.find_by(id: params[:id])
    if triage_event_comment
      triage_event_comment.destroy
      render json: { success: true, message: "Triage event comment deleted" }
    else
      render json: { error: "Triage event comment not found" }, status: :not_found
    end
  end 

  private

  def triage_event_comment_params
    params.require(:triage_event_comment).permit(:triage_event_id, :text, :user_id)
  end
end
