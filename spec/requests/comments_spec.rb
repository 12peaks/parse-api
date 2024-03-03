require 'rails_helper'

RSpec.describe Api::CommentsController, type: :request do
  let(:post_user) { create(:user, :from_omniauth) }
  let(:test_team) { create(:team) }
  let(:test_group) { create(:group, team: test_team) }
  let(:post_obj) { create(:post, user: post_user, group: test_group) }

  before(:each) do
    post_user.teams << test_team
    post_user.current_team = test_team
    post_user.save
    auth_token = post_user.key
    @auth_headers = { 'Authorization': "Bearer #{auth_token}", 'Content-Type': 'application/json' }
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new comment for a post' do
        comment_params = { comment: { content: 'New comment', post_id: post_obj.id } }.to_json
        expect do
          post api_comments_path, params: comment_params, headers: @auth_headers
        end.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a comment' do
        bad_comment_params = { comment: { content: '' } }.to_json
        expect do
          post api_comments_path, params: bad_comment_params, headers: @auth_headers
        end.not_to change(Comment, :count)

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PATCH #update' do
    let(:comment) { create(:comment, user: post_user, post: post_obj) }

    it 'updates the comment' do
      update_comment_params = { comment: { content: 'Updated content' } }.to_json
      patch api_comment_path(comment), params: update_comment_params, headers: @auth_headers
      expect(response).to have_http_status(:ok)
      expect(comment.reload.content).to eq('Updated content')
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment_to_delete) { create(:comment, user: post_user, post: post_obj) }

    it 'deletes the comment' do
      expect do
        delete api_comment_path(comment_to_delete), headers: @auth_headers
      end.to change(Comment, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
