require 'rails_helper'

describe Api::PostsController, type: :request do
  let(:post_user) { create(:user, :from_omniauth) }
  let(:test_team) { create(:team) }
  let(:group) { create(:group, team: test_team) }

  before(:each) do
    post_user.teams << test_team
    post_user.current_team = test_team
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

  describe 'POST #create' do
    let(:post_params) do
      {
        post: {
          content: 'New post content',
          text_content: 'New post content',
          group_id: group.id
        }
      }.to_json
    end

    it 'creates a new post for the current user' do
      expect do
        post api_posts_path, params: post_params, headers: @auth_headers
      end.to change(Post, :count).by(1)

      expect(response).to have_http_status(:success)
    end

    it 'returns an error for invalid parameters' do
      post api_posts_path, params: {}.to_json, headers: @auth_headers

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'PATCH /api/posts/:id' do
    let(:post_to_update) do
      create(:post, user: post_user, team: test_team, group_id: group.id, content: 'Original content')
    end

    it 'updates the post for the user' do
      patch api_post_path(post_to_update), params: { post: { content: 'Updated content' } }.to_json,
                                           headers: @auth_headers

      expect(response).to have_http_status(:ok)
      expect(post_to_update.reload.content).to eq('Updated content')
    end

    it 'returns an error for a post not owned by the user' do
      another_user = create(:user, :from_omniauth, email: 'testuser2@test.com')
      post_not_owned = create(:post, user: another_user, team: test_team, group_id: group.id)

      patch api_post_path(post_not_owned), params: { post: { content: 'Attempted update' } }.to_json,
                                           headers: @auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
