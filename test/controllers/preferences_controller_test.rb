require 'test_helper'

class PreferencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @preference = preferences(:one)
  end

  test "should get index" do
    get preferences_url
    assert_response :success
  end

  test "should get new" do
    get new_preference_url
    assert_response :success
  end

  test "should create preference" do
    assert_difference('Preference.count') do
      post preferences_url, params: { preference: { carrier: @preference.carrier, container_weight: @preference.container_weight, default_box_size: @preference.default_box_size, default_charge: @preference.default_charge, default_weight: @preference.default_weight, flat_rate: @preference.flat_rate, free_Shipping_description: @preference.free_Shipping_description, free_shipping_by_collection: @preference.free_shipping_by_collection, free_shipping_option: @preference.free_shipping_option, height: @preference.height, hide_welcome_note: @preference.hide_welcome_note, items_per_box: @preference.items_per_box, length: @preference.length, offers_flat_rate: @preference.offers_flat_rate, origin_postal_code: @preference.origin_postal_code, rate_lookup_error: @preference.rate_lookup_error, shipping_methods_allowed_dom: @preference.shipping_methods_allowed_dom, shipping_methods_allowed_int: @preference.shipping_methods_allowed_int, shipping_methods_desc_dom: @preference.shipping_methods_desc_dom, shipping_methods_desc_int: @preference.shipping_methods_desc_int, shipping_methods_long_desc_dom: @preference.shipping_methods_long_desc_dom, shipping_methods_long_desc_int: @preference.shipping_methods_long_desc_int, shop_url: @preference.shop_url, surcharge_amount: @preference.surcharge_amount, surcharge_percentage: @preference.surcharge_percentage, under_weight: @preference.under_weight, width: @preference.width } }
    end

    assert_redirected_to preference_url(Preference.last)
  end

  test "should show preference" do
    get preference_url(@preference)
    assert_response :success
  end

  test "should get edit" do
    get edit_preference_url(@preference)
    assert_response :success
  end

  test "should update preference" do
    patch preference_url(@preference), params: { preference: { carrier: @preference.carrier, container_weight: @preference.container_weight, default_box_size: @preference.default_box_size, default_charge: @preference.default_charge, default_weight: @preference.default_weight, flat_rate: @preference.flat_rate, free_Shipping_description: @preference.free_Shipping_description, free_shipping_by_collection: @preference.free_shipping_by_collection, free_shipping_option: @preference.free_shipping_option, height: @preference.height, hide_welcome_note: @preference.hide_welcome_note, items_per_box: @preference.items_per_box, length: @preference.length, offers_flat_rate: @preference.offers_flat_rate, origin_postal_code: @preference.origin_postal_code, rate_lookup_error: @preference.rate_lookup_error, shipping_methods_allowed_dom: @preference.shipping_methods_allowed_dom, shipping_methods_allowed_int: @preference.shipping_methods_allowed_int, shipping_methods_desc_dom: @preference.shipping_methods_desc_dom, shipping_methods_desc_int: @preference.shipping_methods_desc_int, shipping_methods_long_desc_dom: @preference.shipping_methods_long_desc_dom, shipping_methods_long_desc_int: @preference.shipping_methods_long_desc_int, shop_url: @preference.shop_url, surcharge_amount: @preference.surcharge_amount, surcharge_percentage: @preference.surcharge_percentage, under_weight: @preference.under_weight, width: @preference.width } }
    assert_redirected_to preference_url(@preference)
  end

  test "should destroy preference" do
    assert_difference('Preference.count', -1) do
      delete preference_url(@preference)
    end

    assert_redirected_to preferences_url
  end
end
