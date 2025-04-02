module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show]

      def index
        @users = User.all

        render json: @users
      end

      def show
        render json: @user
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def login
        @user = User.find_by_email(user_params[:email])
        if @user&.authenticate(user_params[:password])
          render json: {
            token: JsonWebToken.encode(user_id: @user.id),
            email: @user.email
          }
        else
          render json: {message: 'Invalid Email or Password'}, status: :unauthorized
        end
      end

      private

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:full_name, :phone_number, :email, :password)
        end
    end
  end
end
