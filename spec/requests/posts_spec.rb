require 'rails_helper'

describe Api::PostsController, type: :request do
  let(:post_user) { create(:user, :from_omniauth) }
  let(:team) { create(:team) }
  before(:each) do
    post_user.teams << team
    post_user.current_team = team
    post_user.save
    auth_token = post_user.key
    @auth_headers = { 'Authorization': "Bearer #{auth_token}", 'Content-Type': 'application/json' }
  end

  describe 'GET #index' do
    it 'assigns posts for the logged in user' do
      create(:post, user: post_user)

      get api_posts_path, headers: @auth_headers

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response.first['user']['id']).to eq(post_user.id)
    end
  end
end
