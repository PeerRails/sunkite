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

  def get_all_images_waht
    loger = Logger.new 'debug.txt'
    q = "from:#{user_params[:user]} filter:images"
    opt = {}
    length = 2
    response = []
    begin
      until length == 0
        tweets = client.search(q, opt).to_a
        loger.debug tweets
        if tweets != []
          response += tweets
          length = response.count
          opt = {max_id: response.last.id}
          loger.debug opt
        end
      end
      render json: response
    rescue Twitter::Error, Timeout::Error => e
      if e.class == Twitter::Error::TooManyRequests
        sleep e.rate_limit.reset_in + 1
        retry
      elsif e.class.superclass.name == Twitter::Error
        error = {"error" => "Server is Busy"}
        render json: error
      else
        error = {"error" => e}
        render json: error
      end
    end
  end

  private
  def make_request (user, action)
    timeline_opt = {trim_user: false, count: 100}
    search_opt = {}
    begin
      response = client.user(user) if action == 'get_user'
      response = client.user_timeline(user, timeline_opt) if action == 'get_tweets'

      if action == 'get_images'
        q = "from:#{user} filter:images"
        response = client.search(q, search_opt)
      end
      return response
    rescue Twitter::Error, Timeout::Error => e
      if e.class == Twitter::Error::TooManyRequests
        sleep e.rate_limit["x-rate-limit-reset"] + 1
        retry
      elsif e.class.superclass.name == Twitter::Error
        return {"error" => "Server is Busy"}
      else
        return {"error" => e}
      end
    end
  end

  private
  def user_params
    params.permit(:user)
  end

  private
  def check_params
    if user_params[:user].nil?
      render json: {"error" => "NoParams"}, status: 403
    end
  end
end