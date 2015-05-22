require 'test_helper'

class UserControllerTest < ActionController::TestCase

  setup do
    #@user = client.user('gem')
  end

  test "should get user" do
    get :get_user, {user: 'gem'}
    body = JSON.parse(response.body)
    assert_equal 'gem', body["screen_name"]
    assert_response :success
  end

  test "should get tweets" do
    get :get_tweets, {user: 'gem'}
    body = JSON.parse(response.body)
    assert_equal 'gem', body[0]["user"]["screen_name"]
    assert_response :success
  end

  test "should get images" do
    get :get_images, {user: 'twitter'}
    body = JSON.parse(response.body)
    assert_equal 'twitter', body[0]["user"]["screen_name"]
    assert_response :success
  end

  test "should get user exception" do
    get :get_user, {user: 'gemificide'}
    body = JSON.parse(response.body)
    assert_equal 'NotFound', body["error"]
    assert_response :success
  end

  test "should get tweet exception" do
    get :get_tweets, {user: 'gemificide'}
    body = JSON.parse(response.body)
    assert_equal 'NotFound', body["error"]
    assert_response :success
  end

  test "should get image null" do
    get :get_images, {user: 'gemificide'}
    body = JSON.parse(response.body)
    assert_equal [], body
    assert_response :success
  end

  test "should get user params error" do
    get :get_user
    body = JSON.parse(response.body)
    assert_equal 'NoParams', body["error"]
    assert_response(403)
  end

  test "should get tweet params error" do
    get :get_tweets
    body = JSON.parse(response.body)
    assert_equal 'NoParams', body["error"]
    assert_response(403)
  end

end
