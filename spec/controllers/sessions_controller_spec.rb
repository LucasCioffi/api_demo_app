require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  describe 'POST #create' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password') }

    context 'with valid credentials' do
      it 'returns a successful response with user data' do
        post :create, params: { email: 'test@example.com', password: 'password' }
        
        expect(response).to have_http_status(:created)
        expect(response).to match_response_schema('user')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post :create, params: { email: 'invalid@example.com', password: 'wrongpassword' }
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
