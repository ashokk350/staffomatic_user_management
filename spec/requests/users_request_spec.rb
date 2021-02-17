require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) do
    User.create(
      email: 'danie@example.com',
      password: 'supersecurepassword',
      password_confirmation: 'supersecurepassword',
    )
  end

  before(:each) do
    @auth_token = authenticate_user(user)
    @headers = { 'Authentication' => "Bearer #{@auth_token}" }
  end

  describe 'GET /index' do
    it 'returns http success' do
      get users_path, headers: @headers
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      put "/users/#{user.id}", params: { user: { archived_by: 1, archived: true } }, headers: @headers
      expect(response).to have_http_status(:success)
    end

    it 'returns http success' do
      put "/users/#{user.id}", params: { user: { archived_by: 1, archived: false } }, headers: @headers
      expect(response).to have_http_status(:success)
    end
  end
end
