# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'callbacks' do
    describe '#acts_as_token_authenticatable' do
      it 'generates an authentication token after creating a user' do
        user = build(:user) # Using build to avoid hitting the database
        expect(user.authentication_token).to be_nil

        user.save
        expect(user.authentication_token).not_to be_nil
      end
    end
  end
end
