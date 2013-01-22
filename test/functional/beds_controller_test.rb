require 'test_helper'

class BedsControllerTest < ActionController::TestCase
  setup do
    @bed = beds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bed" do
    assert_difference('Bed.count') do
      post :create, bed: @bed.attributes
    end

    assert_redirected_to bed_path(assigns(:bed))
  end

  test "should show bed" do
    get :show, id: @bed.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bed.to_param
    assert_response :success
  end

  test "should update bed" do
    put :update, id: @bed.to_param, bed: @bed.attributes
    assert_redirected_to bed_path(assigns(:bed))
  end

  test "should destroy bed" do
    assert_difference('Bed.count', -1) do
      delete :destroy, id: @bed.to_param
    end

    assert_redirected_to beds_path
  end
end
