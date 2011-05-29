require 'test_helper'

class SiteGuidesControllerTest < ActionController::TestCase
  setup do
    @site_guide = site_guides(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_guides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_guide" do
    assert_difference('SiteGuide.count') do
      post :create, :site_guide => @site_guide.attributes
    end

    assert_redirected_to site_guide_path(assigns(:site_guide))
  end

  test "should show site_guide" do
    get :show, :id => @site_guide.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @site_guide.to_param
    assert_response :success
  end

  test "should update site_guide" do
    put :update, :id => @site_guide.to_param, :site_guide => @site_guide.attributes
    assert_redirected_to site_guide_path(assigns(:site_guide))
  end

  test "should destroy site_guide" do
    assert_difference('SiteGuide.count', -1) do
      delete :destroy, :id => @site_guide.to_param
    end

    assert_redirected_to site_guides_path
  end
end
