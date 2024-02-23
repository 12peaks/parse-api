class Api::TriageTimelineEventsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    if params[:triage_event_id]
      triage_timeline_events = TriageTimelineEvent.where(triage_event_id: params[:triage_event_id]).order(created_at: :asc)
    else
      triage_timeline_events = TriageTimelineEvent.all.order(created_at: :asc)
    end

    render json: triage_timeline_events, include: { user: { only: [:id, :name, :avatar_url] } }
  end
  
  def create
    user = current_user || api_user
    triage_timeline_event = TriageTimelineEvent.new(triage_timeline_event_params)
    triage_timeline_event.user = user
    
    if triage_timeline_event.save
      render json: triage_timeline_event, include: { user: { only: [:id, :name, :avatar_url] } }
    else
      render json: { error: triage_timeline_event.errors.full_messages }, status: :bad_request
    end
  end

  def update
    user = current_user || api_user
    triage_timeline_event = TriageTimelineEvent.find_by(id: params[:id])
    if triage_timeline_event
      if triage_timeline_event.update(triage_timeline_event_params)
        render json: triage_timeline_event, include: { user: { only: [:id, :name, :avatar_url] } }
      else
        render json: { error: triage_timeline_event.errors.full_messages }, status: :bad_request
      end
    else
      render json: { error: "Triage timeline event not found" }, status: :not_found
    end
  end

  def destroy
    user = current_user || api_user
    triage_timeline_event = TriageTimelineEvent.find_by(id: params[:id])
    if triage_timeline_event
      triage_timeline_event.destroy
      render json: { success: true, message: "Triage timeline event deleted" }
    else
      render json: { error: "Triage timeline event not found" }, status: :not_found
    end
  end

  private

  def triage_timeline_event_params
    params.require(:triage_timeline_event).permit(:triage_event_id, :old_value, :new_value, :user, :field)
  end
end
