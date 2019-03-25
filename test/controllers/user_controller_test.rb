require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get member_profile" do
    get user_member_profile_url
    assert_response :success
  end

end
