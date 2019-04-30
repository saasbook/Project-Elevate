require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
   # For Devise >= 4.2.0
  include Devise::Test::ControllerHelpers
   # Use the following instead if you are on Devise <= 4.2.0
   # include Devise::TestHelpers                         
  include Warden::Test::Helpers                        
  Warden.test_mode!                                    

  def teardown                                         
    Warden.test_reset!                                 
  end                         
   
  def setup
     @request.env["devise.mapping"] = Devise.mappings[:admin]
     sign_in FactoryBot.create(:admin)
  end
end
