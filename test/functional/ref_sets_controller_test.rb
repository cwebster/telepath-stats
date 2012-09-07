require 'test_helper'

class RefSetsControllerTest < ActionController::TestCase
  setup do
    @ref_set = ref_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ref_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ref_set" do
    assert_difference('RefSet.count') do
      post :create, :ref_set => @ref_set.attributes
    end

    assert_redirected_to ref_set_path(assigns(:ref_set))
  end

  test "should show ref_set" do
    get :show, :id => @ref_set.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ref_set.to_param
    assert_response :success
  end

  test "should update ref_set" do
    put :update, :id => @ref_set.to_param, :ref_set => @ref_set.attributes
    assert_redirected_to ref_set_path(assigns(:ref_set))
  end

  test "should destroy ref_set" do
    assert_difference('RefSet.count', -1) do
      delete :destroy, :id => @ref_set.to_param
    end

    assert_redirected_to ref_sets_path
  end
end
