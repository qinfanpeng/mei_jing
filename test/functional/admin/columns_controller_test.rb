require 'test_helper'

class Admin::ColumnsControllerTest < ActionController::TestCase
  setup do
    @admin_column = admin_columns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_columns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_column" do
    assert_difference('Admin::Column.count') do
      post :create, admin_column: { name: @admin_column.name }
    end

    assert_redirected_to admin_column_path(assigns(:admin_column))
  end

  test "should show admin_column" do
    get :show, id: @admin_column
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_column
    assert_response :success
  end

  test "should update admin_column" do
    put :update, id: @admin_column, admin_column: { name: @admin_column.name }
    assert_redirected_to admin_column_path(assigns(:admin_column))
  end

  test "should destroy admin_column" do
    assert_difference('Admin::Column.count', -1) do
      delete :destroy, id: @admin_column
    end

    assert_redirected_to admin_columns_path
  end
end
