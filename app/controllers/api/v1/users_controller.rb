module Api
  module V1
    class UsersController < ApplicationController
 
      def index
        users = User.all
        render json: users.as_json(only: [:id, :username, :email, :role])
      end

      def create
        user = User.new(user_params)

        if user.save
          session[:user_id] = user.id  #
          render json: user.as_json(only: [:id, :username, :email, :role]), status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password, :role)
      end
    end
  end
end
