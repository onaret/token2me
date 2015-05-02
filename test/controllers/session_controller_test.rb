require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  
  setup do
    @eddy = users(:ed)
  end

  test "should get log_in" do
    get :login, name: @eddy.name, password: 'unset'
    assert_redirected_to root_path
  end

  test "should get log_out" do
    get :logout
    assert_redirected_to root_path
  end

  test "should go to session login" do
    get :new
    assert_response :success 
  end

  test "should get to token path as a user is already logged in" do
    session[:user_id] = @eddy
    get :new
    assert_redirected_to tokens_path('server')
  end

end
