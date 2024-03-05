require 'rails_helper'

RSpec.describe Api::NotificationsController, type: :request do
  let(:user) { create(:user, :from_omniauth) }
  let!(:notifications) { create_list(:notification, 5, notify_user: user, status: 'unread') }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    before do
      get api_notifications_path, headers:
    end

    it 'returns all notifications for the current user' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json.length).to eq(5)
    end
  end

  describe 'PUT #update' do
    let(:notification) { notifications.first }
    let(:update_notification_params) { { notification: { status: 'read' } } }

    before do
      put api_notification_path(notification), params: update_notification_params, headers:
    end

    it 'updates the notification' do
      expect(response).to have_http_status(:ok)
      expect(notification.reload.status).to eq('read')
    end
  end

  describe 'DELETE #destroy' do
    let(:notification_to_delete) { notifications.first }

    it 'deletes the notification' do
      expect do
        delete api_notification_path(notification_to_delete), headers:
      end.to change(Notification, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #unread_count' do
    before do
      get '/api/notifications/unread_count', headers:
    end

    it 'returns the count of unread notifications' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json['count']).to eq(5)
    end
  end

  describe 'POST #mark_all_as_read' do
    before do
      post '/api/notifications/mark_all_as_read', headers:
    end

    it 'marks all notifications as read' do
      expect(response).to have_http_status(:ok)
      expect(user.notifications.unread.count).to eq(0)
    end
  end

  describe 'DELETE #destroy_all' do
    before do
      post '/api/notifications/remove_all', headers:
    end

    it 'deletes all notifications' do
      expect(response).to have_http_status(:ok)
      expect(user.notifications.count).to eq(0)
    end
  end
end
