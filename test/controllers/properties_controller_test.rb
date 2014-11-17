require 'test_helper'

class PropertiesControllerTest < ActionController::TestCase
  setup do
    @property = properties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:properties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create property" do
    assert_difference('Property.count') do
      post :create, property: { address1: @property.address1, address2: @property.address2, address3: @property.address3, amount: @property.amount, bath: @property.bath, beds: @property.beds, date: @property.date, description: @property.description, image1: @property.image1, image2: @property.image2, image3: @property.image3, image4: @property.image4, image5: @property.image5, image6: @property.image6, parking: @property.parking, visibility: @property.visibility }
    end

    assert_redirected_to property_path(assigns(:property))
  end

  test "should show property" do
    get :show, id: @property
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @property
    assert_response :success
  end

  test "should update property" do
    patch :update, id: @property, property: { address1: @property.address1, address2: @property.address2, address3: @property.address3, amount: @property.amount, bath: @property.bath, beds: @property.beds, date: @property.date, description: @property.description, image1: @property.image1, image2: @property.image2, image3: @property.image3, image4: @property.image4, image5: @property.image5, image6: @property.image6, parking: @property.parking, visibility: @property.visibility }
    assert_redirected_to property_path(assigns(:property))
  end

  test "should destroy property" do
    assert_difference('Property.count', -1) do
      delete :destroy, id: @property
    end

    assert_redirected_to properties_path
  end
end
