require 'test_helper'

class ConnectFourControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :found
  end

end