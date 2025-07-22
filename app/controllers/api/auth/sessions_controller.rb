module Api
  module Auth
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:csrf_token]

      def show
        if session[:user_id]
          user = User.find_by(id: session[:user_id])
          render json: { user: user }
        else
          render json: { user: nil }
        end
      end

      def create
        user_params = params[:user] || params.dig(:session, :user)
        if user_params
          user = User.find_by(email: user_params[:email].downcase)
          if user && user.authenticate(user_params[:password])
            session[:user_id] = user.id
            render json: { user: user }, status: :created
          else
            render json: { error: "Invalid email/password" }, status: :unauthorized
          end
        else
          render json: { error: "Missing user credentials" }, status: :bad_request
        end
      end

      def destroy
        session[:user_id] = nil
        head :no_content
      end

      def csrf_token
        render json: { csrf_token: form_authenticity_token }
      end
    end
  end
end