FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    total_games_played { 0 }
  end
end