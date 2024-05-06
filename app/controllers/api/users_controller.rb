class Api::UsersController < ApplicationController

  def create
    user = User.new(user_params)

    if user.save
      render json: {user: user.as_json(only: [:email, :authentication_token])}, status: :created
    else
      render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

end