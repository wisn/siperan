require 'test_helper'

class DeveloperControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get developer_index_url
    assert_response :success
  end

end
