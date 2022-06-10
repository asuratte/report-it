require "test_helper"

class ResidentControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get resident_index_url
    assert_response :success
  end
end
