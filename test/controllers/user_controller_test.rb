require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get member_profile" do
    get user_member_profile_url
    assert_response :success
  end

  include Devise::TestHelpers                          
  include Warden::Test::Helpers                        
  Warden.test_mode!                                    

  def teardown                                         
    Warden.test_reset!                                 
  end                                 

end


