class Api::TriageEventsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    user = current_user || api_user
    triage_events = user.current_team.triage_events.order(created_at: :desc)
    render json: triage_events
  end

  def create
    user = current_user || api_user
    triage_event = TriageEvent.new(triage_event_params)
    triage_event.user = user
    triage_event.team = user.current_team
    
    if triage_event.save
      render json: triage_event.as_json(include: 
        [{user: {methods: [:avatar_image_url]}}, {owner: {methods: [:avatar_image_url]}},
          {triage_event_comments: {include: {user: {only: [:id, :name], methods: [:avatar_image_url]}}}}],
           methods: :attachments_data)
    else
      render json: { error: triage_event.errors.full_messages }, status: :bad_request
    end
  end

  def show
    user = current_user || api_user
    triage_event = user.current_team.triage_events.find_by(id: params[:id])
    if triage_event
      render json: triage_event.as_json(include: 
        [{user: {methods: [:avatar_image_url]}}, {owner: {methods: [:avatar_image_url]}},
          {triage_event_comments: {include: {user: {only: [:id, :name], methods: [:avatar_image_url]}}}}],
           methods: :attachments_data)
    else
      render json: { error: "Triage event not found in your current team" }, status: :not_found
    end
  end

  def update
    user = current_user || api_user
    triage_event = user.current_team.triage_events.find_by(id: params[:id])
    if triage_event
      if triage_event.update(triage_event_params)
        render json: triage_event.as_json(include: 
          [{user: {methods: [:avatar_image_url]}}, {owner: {methods: [:avatar_image_url]}},
            {triage_event_comments: {include: {user: {only: [:id, :name], methods: [:avatar_image_url]}}}}],
             methods: :attachments_data)
      else
        render json: { error: triage_event.errors.full_messages }, status: :bad_request
      end
    else
      render json: { error: "Triage event not found in your current team" }, status: :not_found
    end
  end

  def destroy
    user = current_user || api_user
    triage_event = user.current_team.triage_events.find_by(id: params[:id])
    if triage_event
      triage_event.destroy
      render json: { success: true, message: "Triage event deleted" }
    else
      render json: { error: "Triage event not found in your current team" }, status: :not_found
    end
  end

  private

  def triage_event_params
    params.require(:triage_event).permit(:description, :severity, :status, :owner_id, :team_id, :user, :user_id, attachments: [])
  end
end
