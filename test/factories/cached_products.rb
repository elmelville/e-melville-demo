FactoryGirl.define do
  factory :cached_product do
    product_id "MyString"
    shop_id 1
    sku "MyString"
    height "9.99"
    width "9.99"
    length "9.99"
    product_name "MyString"
    large_item "MyString"
    small_item "MyString"
    max_small 1
    cost_adjustment "9.99"
  end
end
