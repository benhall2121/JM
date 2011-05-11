require 'test_helper'

class CommentariesControllerTest < ActionController::TestCase
  setup do
    @commentary = commentaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:commentaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create commentary" do
    assert_difference('Commentary.count') do
      post :create, :commentary => @commentary.attributes
    end

    assert_redirected_to commentary_path(assigns(:commentary))
  end

  test "should show commentary" do
    get :show, :id => @commentary.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @commentary.to_param
    assert_response :success
  end

  test "should update commentary" do
    put :update, :id => @commentary.to_param, :commentary => @commentary.attributes
    assert_redirected_to commentary_path(assigns(:commentary))
  end

  test "should destroy commentary" do
    assert_difference('Commentary.count', -1) do
      delete :destroy, :id => @commentary.to_param
    end

    assert_redirected_to commentaries_path
  end
end
