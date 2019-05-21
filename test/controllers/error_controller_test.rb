require 'test_helper'

class ErrorControllerTest < ActionDispatch::IntegrationTest
  test "should get error" do
    get error_error_url
    assert_response :success
  end

  include Devise::TestHelpers                          
  include Warden::Test::Helpers                        
  Warden.test_mode!                                    

  def teardown                                         
    Warden.test_reset!                                 
  end                

end

