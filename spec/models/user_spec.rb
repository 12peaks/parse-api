require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:api_keys).dependent(:destroy) }
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:reactions) }
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_many(:triage_events) }
    it { is_expected.to have_many(:triage_event_comments) }
    it { is_expected.to have_many(:triage_timeline_events) }
    it { is_expected.to have_many(:polls) }
    it { is_expected.to have_many(:poll_options).through(:polls) }
    it { is_expected.to have_many(:poll_votes) }
    it { is_expected.to have_many(:goals) }
    it { is_expected.to have_many(:goal_collaborators) }
    it { is_expected.to have_many(:goal_updates) }
    it { is_expected.to have_many(:mentions) }
    it { is_expected.to have_many(:group_users) }
    it { is_expected.to have_many(:groups).through(:group_users) }
    it { is_expected.to have_and_belong_to_many(:teams) }
    it { is_expected.to belong_to(:current_team).class_name('Team').optional }
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe '.from_omniauth' do
    let(:auth_mock) do
      OmniAuth::AuthHash.new({
                               provider: 'github',
                               uid: '123545',
                               info: {
                                 email: 'user@test.com',
                                 name: 'Test User',
                                 image: 'https://test.com/image.jpg'
                               },
                               extra: {
                                 raw_info: {
                                   twitter_username: 'test_user'
                                 }
                               }
                             })
    end

    context 'when user does not exist' do
      it 'creates a new user' do
        expect { described_class.from_omniauth(auth_mock) }.to change(described_class, :count).by(1)
      end

      it 'returns the new user' do
        user = described_class.from_omniauth(auth_mock)
        expect(user).to be_a(described_class)
        expect(user.email).to eq('user@test.com')
        expect(user.name).to eq('Test User')
        expect(user.avatar_url).to eq('https://test.com/image.jpg')
      end
    end

    context 'when user exists' do
      let!(:existing_user) { create(:user, :from_omniauth, email: 'user@test.com', provider: 'github', uid: '123545') }

      it 'does not create a new user' do
        expect { described_class.from_omniauth(auth_mock) }.not_to change(described_class, :count)
      end

      it 'updates the existing user' do
        user = described_class.from_omniauth(auth_mock)
        expect(user).to eq(existing_user)
        expect(user.email).to eq('user@test.com')
        expect(user.name).to eq('Test User')
      end
    end
  end

  describe '#key' do
    let(:user) { create(:user, :from_omniauth) }

    before do
      user.api_keys.create
    end

    it 'returns the first API key' do
      expect(user.key).to eq(user.api_keys.first.key)
    end
  end

  describe '#avatar_image_url' do
    let(:user) { create(:user, :from_omniauth) }
    context 'when an avatar is attached' do
      before do
        user.avatar.attach(io: File.open('spec/fixtures/files/avatar.png'), filename: 'avatar.png',
                           content_type: 'image/png')
        user.save!
      end
      it 'returns the URL for the avatar' do
        expect(user.avatar_image_url).to include('rails/active_storage')
      end
    end
    context 'when an avatar is not attached' do
      it 'returns the avatar_url' do
        expect(user.avatar_image_url).to eq(user.avatar_url)
      end
    end
  end

  describe 'callbacks' do
    context 'after creating a user' do
      let(:user) { build(:user, :from_omniauth) }
      it 'generates a new API key' do
        expect { user.save }.to change(user.api_keys, :count).by(1)
      end

      it 'assigns the user to a default team' do
        expect { user.save }.to change(user.teams, :count).by(1)
        expect(user.current_team).to eq(user.teams.first)
        expect(user.current_team).not_to be_nil
      end
    end
  end
end
