class Api::NotificationsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    user = current_user || api_user
    notifications = Notification.for_notify_user(user.id).order(created_at: :desc)
    render json: notifications
  end

  def update
    user = current_user || api_user
    notification = Notification.for_notify_user(user.id).find_by(id: params[:id])
    if notification.update(notification_params)
      render json: notification
    else
      render json: { error: notification.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    user = current_user || api_user
    notification = Notification.for_notify_user(user.id).find_by(id: params[:id])
    if notification.nil?
      return render json: { error: "Notification not found" }, status: :not_found
    end
    notification.destroy
    render json: { success: true, message: "Notification deleted" }
  end

  def unread_count
    user = current_user || api_user
    count = Notification.for_notify_user(user.id).where(status: "unread").count
    render json: { count: count }
  end
  
  def mark_all_as_read
    user = current_user || api_user
    notifications = Notification.for_notify_user(user.id)
    notifications.update_all(status: "read")
    render json: { success: true, message: "All notifications marked as read" }
  end 

  def destroy_all
    user = current_user || api_user
    notifications = Notification.for_notify_user(user.id)
    notifications.destroy_all
    render json: { success: true, message: "All notifications deleted" }
  end

  private

  def notification_params
    params.require(:notification).permit(:status, :text, :image_url, :target_model, 
      :target_model_id, :user_id, :post_id, :group_id, :notify_user_id)
  end
end
