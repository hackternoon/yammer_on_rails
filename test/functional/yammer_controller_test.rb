require 'test_helper'

class YammerControllerTest < ActionController::TestCase
  test "should get client" do
    get :client
    assert_response :success
  end

end
