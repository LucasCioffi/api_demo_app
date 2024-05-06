require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'returns a successful response with user data' do
        # Note: The password_confirmation parameter is currently optional.  If present, it must match the password parameter.
        post :create, params: { email: 'test@example.com', password: 'password' }
        
        expect(response).to have_http_status(:created)
        expect(response).to match_response_schema('user')
      end
    end

    context 'with invalid credentials' do
      context 'if password is missing' do
        it 'returns unprocessable_entity status' do
          post :create, params: { email: 'test@example.com' }
          
          expect(response).to have_http_status(:unprocessable_entity)

          expected_response = { 'error' => "Password can't be blank" }
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end

      context 'if email is missing' do
        it 'returns unprocessable_entity status' do
          post :create, params: { password: 'password', password_confirmation: 'password' }
          
          expect(response).to have_http_status(:unprocessable_entity)

          expected_response = { 'error' => "Email can't be blank" }
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end

      context 'if password and password_confirmation do not match' do
        it 'returns unprocessable_entity status' do
          post :create, params: { email: 'test@example.com', password: 'password', password_confirmation: 'wrong_password' }
          
          expect(response).to have_http_status(:unprocessable_entity)

          expected_response = { 'error' => "Password confirmation doesn't match Password" }
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end
    end

    context 'with duplicate user' do
      let!(:existing_user) { create(:user, email: 'test@example.com', password: 'password') }

      it 'returns unprocessable_entity status' do
        post :create, params: { email: 'test@example.com', password: 'password' }
        
        expect(response).to have_http_status(:unprocessable_entity)

        expected_response = { 'error' => 'Email has already been taken' }
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end

  describe "GET #user_details" do
    context "when user is not authenticated" do
      it "returns HTTP unauthorized" do
        get :user_details
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      let(:user) { create(:user) }
      let(:auth_headers) { {
          'X-User-Email' => user.email,
          'X-User-Token' => user.authentication_token
        }
      }

      before { request.headers.merge!(auth_headers) }
  
      it "returns HTTP success" do
        get :user_details
        expect(response).to have_http_status(:ok)
      end

      it "returns user details" do
        get :user_details
        user_json = JSON.parse(response.body)["user"]
        expect(response).to match_response_schema('user_details')
        expect(user_json["id"]).to eq(user.id)
        expect(user_json["stats"]["total_games_played"]).to eq(user.total_games_played)
      end
    end
  end
end