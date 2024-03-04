require 'rails_helper'

RSpec.describe Api::GroupsController, type: :request do
  let(:user) { create(:user, :from_omniauth) }
  let(:team) { create(:team) }
  let!(:user_team) do
    user.teams << team
    user.update(current_team: team)
  end
  let(:group) { create(:group, team:) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    before do
      get api_groups_path, headers:
    end

    it 'returns all groups for the current user team' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json.length).to eq(team.groups.count)
    end
  end

  describe 'GET #show' do
    context 'when group exists in the users current team' do
      before do
        get api_group_path(group), headers:
      end

      it 'returns the group' do
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json['id']).to eq(group.id)
      end
    end

    context 'when the group does not exist in the users current team' do
      before do
        get api_group_path(0), headers:
      end

      it 'returns not found' do
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Group not found in your current team')
      end
    end
  end

  describe 'POST #create' do
    let(:group_params) { { group: { name: 'Amazing Group', description: 'A new amazing group' } } }

    it 'creates a new group' do
      expect do
        post(api_groups_path, params: group_params, headers:)
      end.to change(Group, :count).by(1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT #update' do
    let(:update_params) { { group: { name: 'Updated Name' } } }

    before do
      put api_group_path(group), params: update_params, headers:
    end

    it 'updates the group' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json['name']).to eq('Updated Name')
    end
  end

  describe 'DELETE #destroy' do
    let!(:group_to_delete) { create(:group, team:) }

    it 'deletes the group' do
      expect do
        delete api_group_path(group_to_delete), headers:
      end.to change(Group, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end
