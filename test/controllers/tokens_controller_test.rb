require 'test_helper'

class TokensControllerTest < ActionController::TestCase
  setup do
    @token_srv = tokens(:active_srv)
    session[:user_id] = users(:ed).id
  end

  test "should get index" do
    get :index, access_type: 'server'
    assert_redirected_to tokens_path('server')
  end

  test "should get new" do
    get :new, access_type: 'server'
    assert_response :success
  end

  test "should create token" do
    assert_difference('Token.count') do
    post :create, token: { comment: @token_srv.comment, status: @token_srv.status, user_id: @token_srv.user_id}, access_type: 'server'
  end
    assert_redirected_to tokens_path('server')
  end

  test "should release token" do
    get :release_token, access_type: 'server'
    assert_redirected_to tokens_path('server')
  end
end
