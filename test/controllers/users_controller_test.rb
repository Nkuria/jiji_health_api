# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @user_params = {
          user: {
            full_name: 'Test User',
            phone_number: '+254712345678',
            email: 'test@example.com',
            password: 'password123'
          }
        }
        @invalid_user_params = {
          user: {
            full_name: '',
            phone_number: '',
            email: 'invalid-email',
            password: 'pwd'
          }
        }
      end

      test 'should get index' do
        get api_v1_users_url, as: :json
        assert_response :success

        json_response = JSON.parse(response.body)
        assert_not_empty json_response
      end

      test 'should show user' do
        get api_v1_user_url(@user), as: :json
        assert_response :success

        json_response = JSON.parse(response.body)
        assert_equal @user.email, json_response['email']
        assert_equal @user.full_name, json_response['full_name']
        assert_equal @user.phone_number, json_response['phone_number']
      end

      test 'should create user with valid params' do
        assert_difference('User.count') do
          post api_v1_users_url, params: @user_params, as: :json
        end

        assert_response :created

        json_response = JSON.parse(response.body)
        assert_equal @user_params[:user][:email], json_response['email']
        assert_equal @user_params[:user][:full_name], json_response['full_name']
        assert_equal @user_params[:user][:phone_number], json_response['phone_number']
      end

      test 'should not create user with invalid params' do
        assert_no_difference('User.count') do
          post api_v1_users_url, params: @invalid_user_params, as: :json
        end

        assert_response :unprocessable_entity
      end

      test 'should login user with valid credentials' do
        post api_v1_users_sign_in_url, params: {
          user: {
            email: @user.email,
            password: 'password123'
          }
        }, as: :json

        assert_response :success

        json_response = JSON.parse(response.body)
        assert_includes json_response.keys, 'token'
        assert_includes json_response.keys, 'email'
        assert_equal @user.email, json_response['email']
      end

      test 'should not login user with invalid email' do
        post api_v1_users_sign_in_url, params: {
          user: {
            email: 'wrong@example.com',
            password: 'password'
          }
        }, as: :json

        assert_response :unauthorized
      end

      test 'should not login user with invalid password' do
        post api_v1_users_sign_in_url, params: {
          user: {
            email: @user.email,
            password: 'wrongpassword'
          }
        }, as: :json

        assert_response :unauthorized
      end
    end
  end
end
