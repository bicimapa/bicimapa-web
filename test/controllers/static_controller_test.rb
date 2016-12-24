require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test 'the truth' do
    get :index
    assert_response :success
  end
end
