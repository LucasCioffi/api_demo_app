require 'rails_helper'

RSpec.describe Api::GameEventsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:auth_headers) { {
        'X-User-Email' => user.email,
        'X-User-Token' => user.authentication_token
      }
    }

    context 'when user is not authenticated' do
      it 'returns unauthorized status' do
        post :create
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated' do
      before { request.headers.merge!(auth_headers) }

      context 'with valid parameters' do
        let(:game_id) { 1 }
        let(:occurred_at) { Time.now }

        it 'creates a new game event and increments user total_games_played' do
          expect {
            post :create, params: { game_event: { game_id: game_id, occurred_at: occurred_at, type: 'COMPLETED' } }
          }.to change(GameEvent, :count).by(1)

          user.reload
          expect(user.total_games_played).to eq(1)
          expect(response).to have_http_status(:created)
        end
      end

      context 'with missing or invalid parameters' do
        it 'returns unprocessable entity status if game_id is blank' do
          post :create, params: { game_event: { occurred_at: Time.now, type: 'COMPLETED' } }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns unprocessable entity status if occurred_at is blank' do
          post :create, params: { game_event: { game_id: 1, type: 'COMPLETED' } }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns unprocessable entity status if type is not COMPLETED' do
          post :create, params: { game_event: { game_id: 1, occurred_at: Time.now, type: 'IN_PROGRESS' } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
