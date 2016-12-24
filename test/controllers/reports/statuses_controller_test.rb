require 'test_helper'

class Reports::StatusesControllerTest < ActionController::TestCase
  setup do
    @reports_status = reports_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reports_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reports_status" do
    assert_difference('Reports::Status.count') do
      post :create, reports_status: { code: @reports_status.code, description: @reports_status.description, label: @reports_status.label }
    end

    assert_redirected_to reports_status_path(assigns(:reports_status))
  end

  test "should show reports_status" do
    get :show, id: @reports_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reports_status
    assert_response :success
  end

  test "should update reports_status" do
    patch :update, id: @reports_status, reports_status: { code: @reports_status.code, description: @reports_status.description, label: @reports_status.label }
    assert_redirected_to reports_status_path(assigns(:reports_status))
  end

  test "should destroy reports_status" do
    assert_difference('Reports::Status.count', -1) do
      delete :destroy, id: @reports_status
    end

    assert_redirected_to reports_statuses_path
  end
end
