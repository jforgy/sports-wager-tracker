require "test_helper"

class WagersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get wagers_index_url
    assert_response :success
  end

  test "should get show" do
    get wagers_show_url
    assert_response :success
  end

  test "should get new" do
    get wagers_new_url
    assert_response :success
  end

  test "should get create" do
    get wagers_create_url
    assert_response :success
  end

  test "should get edit" do
    get wagers_edit_url
    assert_response :success
  end

  test "should get update" do
    get wagers_update_url
    assert_response :success
  end

  test "should get destroy" do
    get wagers_destroy_url
    assert_response :success
  end
end
