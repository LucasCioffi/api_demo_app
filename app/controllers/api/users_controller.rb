class Api::UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]

  def create
    user = User.new(user_params)

    if user.save
      render json: {user: user.as_json(only: [:email, :authentication_token])}, status: :created
    else
      render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def user_details
    user_json = current_user.as_json(only: [:id, :email])
    user_json['stats'] = { total_games_played: current_user.total_games_played }

    render json: { user: user_json }, status: :ok
  end

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

end