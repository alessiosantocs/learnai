require "test_helper"

class ApplicationConnectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get application_connections_index_url
    assert_response :success
  end

  test "should get new" do
    get application_connections_new_url
    assert_response :success
  end

  test "should get create" do
    get application_connections_create_url
    assert_response :success
  end

  test "should get show" do
    get application_connections_show_url
    assert_response :success
  end

  test "should get destroy" do
    get application_connections_destroy_url
    assert_response :success
  end
end
