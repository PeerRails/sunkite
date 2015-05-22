class UserController < ApplicationController
  before_action :check_params

  def get_user
    render json: make_request(user_params[:user], 'get_user')
  end

  def get_tweets
    render json: make_request(user_params[:user], 'get_tweets')
  end

  def get_images
    render json: make_request(user_params[:user], 'get_images')
  end

  private
  def make_request (user, action)
    begin
      response = client.user(user) if action == 'get_user'
      response = client.user_timeline(user, {trim_user: false, count: 10}) if action == 'get_tweets'

      if action == 'get_images'
        q = "from:#{user} filter:images" if action == 'get_images'
        response = client.search(q) if action == 'get_images'
      end

      return response
    rescue Twitter::Error::NotFound => e
      return response = {"error": "NotFound"}
    end
  end

  def user_params
    params.permit(:user)
  end

  def check_params
    if user_params[:user].nil?
      render json: {"error": "NoParams"}, status: 403
    end
  end
end
