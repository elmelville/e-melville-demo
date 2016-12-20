require 'test_helper'

class CachedProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cached_product = cached_products(:one)
  end

  test "should get index" do
    get cached_products_url
    assert_response :success
  end

  test "should get new" do
    get new_cached_product_url
    assert_response :success
  end

  test "should create cached_product" do
    assert_difference('CachedProduct.count') do
      post cached_products_url, params: { cached_product: { cost_adjustment: @cached_product.cost_adjustment, height: @cached_product.height, large_item: @cached_product.large_item, length: @cached_product.length, max_small: @cached_product.max_small, product_id: @cached_product.product_id, product_name: @cached_product.product_name, shop_id: @cached_product.shop_id, sku: @cached_product.sku, small_item: @cached_product.small_item, width: @cached_product.width } }
    end

    assert_redirected_to cached_product_url(CachedProduct.last)
  end

  test "should show cached_product" do
    get cached_product_url(@cached_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_cached_product_url(@cached_product)
    assert_response :success
  end

  test "should update cached_product" do
    patch cached_product_url(@cached_product), params: { cached_product: { cost_adjustment: @cached_product.cost_adjustment, height: @cached_product.height, large_item: @cached_product.large_item, length: @cached_product.length, max_small: @cached_product.max_small, product_id: @cached_product.product_id, product_name: @cached_product.product_name, shop_id: @cached_product.shop_id, sku: @cached_product.sku, small_item: @cached_product.small_item, width: @cached_product.width } }
    assert_redirected_to cached_product_url(@cached_product)
  end

  test "should destroy cached_product" do
    assert_difference('CachedProduct.count', -1) do
      delete cached_product_url(@cached_product)
    end

    assert_redirected_to cached_products_url
  end
end
