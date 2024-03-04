require 'rails_helper'

describe Api::UsersController, type: :request do
  let(:user) { create(:user, :from_omniauth) }
  let(:team) { create(:team) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET #client_user' do
    context 'when user is logged in' do
      before do
        sign_in user
        get '/api/users/current_user', headers:
      end

      it 'returns the current user information' do
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['id']).to eq(user.id)
      end
    end

    context 'when user is not logged in' do
      before do
        get '/api/users/current_user', headers:
      end

      it 'return unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    let(:user_params) { { user: { name: 'New Name' } } }

    context 'when user is logged in' do
      before do
        sign_in user
        put '/api/users', params: user_params, headers:
      end

      it 'updates the user' do
        expect(response).to have_http_status(:success)
        expect(user.reload.name).to eq('New Name')
      end
    end
  end

  describe 'POST #log_out' do
    before do
      sign_in user
      delete '/api/users/sign_out', headers:
    end

    it 'logs the user out' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(json['message']).to eq('Logged out')
      expect(controller.current_user).to be_nil
    end
  end
end
