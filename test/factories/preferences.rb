FactoryGirl.define do
  factory :preference do
    shop_url "MyString"
    origin_postal_code "MyString"
    default_weight "MyString"
    height 1
    width 1
    length 1
    surcharge_percentage 1.5
    items_per_box 1
    default_charge "9.99"
    shipping_methods_allowed_int "MyString"
    container_weight 1
    shipping_methods_allowed_dom "MyString"
    default_box_size 1
    shipping_methods_desc_int "MyString"
    shipping_methods_desc_dom "MyString"
    surcharge_amount 1.5
    hide_welcome_note false
    carrier "MyString"
    free_shipping_option false
    free_Shipping_description "MyString"
    offers_flat_rate false
    under_weight 1
    flat_rate 1
    free_shipping_by_collection false
    shipping_methods_long_desc_int "MyString"
    shipping_methods_long_desc_dom "MyString"
    rate_lookup_error "MyString"
  end
end
