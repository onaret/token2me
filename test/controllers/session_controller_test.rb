require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  
  setup do
    @eddy = users(:ed)
  end

  test "should login as known user" do
    get :login, name: @eddy.name, password: 'unset'
    assert_redirected_to root_path
  end

  test "should login as first connect" do
    get :login, name: 'go', password: 'unset'
    assert_redirected_to root_path
   # assert_redirected_to edit_user_path(User.all.last)
  #  assert_redirected_to edit_user_path(controller: "user", action: "edit")
 #   assert_redirected_to controller: "user", action: "edit"
  end

  test "should get log_out" do
    get :logout
    assert_redirected_to root_path
    assert_nil(session[:user_id])
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
