module Carriers
  module AusPost
    class Installer < ::Carriers::Installer

      def find_or_create_metafield(shopify_api_shop, key_name, field_value)
        found = shopify_api_shop.metafields.select {|m| m.key == key_name}            
        if (found.length > 0)
          if (found[0].value.to_s != field_value)
            puts("found[0] is #{found[0]}")
            found[0].value = field_value    
            shopify_api_shop.add_metafield(found[0])            
          end                       
        else
          field = ShopifyAPI::Metafield.new({:namespace =>'shipping_helper',:key=>key_name, :value=>field_value, :value_type=>'string' })
          shopify_api_shop.add_metafield(field)
        end
      end

      def configure(params)

          shipping_methods_desc_int = params.require('shipping_methods_long_desc_int').permit(:INT_PARCEL_COR_OWN_PACKAGING, :INT_PARCEL_EXP_OWN_PACKAGING, :INT_PARCEL_STD_OWN_PACKAGING, :INT_PARCEL_AIR_OWN_PACKAGING, :INT_PARCEL_SEA_OWN_PACKAGING)
          shipping_methods_allowed_int = params.require('shipping_methods_allowed_int').permit(:INT_PARCEL_COR_OWN_PACKAGING, :INT_PARCEL_EXP_OWN_PACKAGING, :INT_PARCEL_STD_OWN_PACKAGING, :INT_PARCEL_AIR_OWN_PACKAGING, :INT_PARCEL_SEA_OWN_PACKAGING)
          shipping_methods_allowed_dom = params.require('shipping_methods_allowed_dom').permit(:AUS_PARCEL_REGULAR,:AUS_PARCEL_EXPRESS,:AUS_PARCEL_REGULAR_SATCHEL_500G,:AUS_PARCEL_EXPRESS_SATCHEL_500G,:AUS_PARCEL_REGULAR_SATCHEL_3KG,:AUS_PARCEL_EXPRESS_SATCHEL_3KG,:AUS_PARCEL_REGULAR_SATCHEL_5KG, :AUS_PARCEL_EXPRESS_SATCHEL_5KG)
          shipping_methods_desc_dom = params.require('shipping_methods_long_desc_dom').permit(:AUS_PARCEL_REGULAR,:AUS_PARCEL_EXPRESS,:AUS_PARCEL_REGULAR_SATCHEL_500G,:AUS_PARCEL_EXPRESS_SATCHEL_500G,:AUS_PARCEL_REGULAR_SATCHEL_3KG,:AUS_PARCEL_EXPRESS_SATCHEL_3KG,:AUS_PARCEL_REGULAR_SATCHEL_5KG, :AUS_PARCEL_EXPRESS_SATCHEL_5KG)


          @preference.shipping_methods_allowed_int = shipping_methods_allowed_int.to_h
          @preference.shipping_methods_allowed_dom = shipping_methods_allowed_dom.to_h
          @preference.shipping_methods_desc_dom = shipping_methods_desc_dom.to_h
          @preference.shipping_methods_desc_int = shipping_methods_desc_int.to_h
          @preference.rate_lookup_error = params[:preference][:rate_lookup_error].to_s

          withShopify do
            shopify_api_shop = ShopifyAPI::Shop.current

              find_or_create_metafield(shopify_api_shop, 'rate_lookup_error', @preference.rate_lookup_error.to_s)

              @preference.shipping_methods_long_desc_int.each do |method_name, value|              
                find_or_create_metafield(shopify_api_shop, method_name, value.to_s)                       
              end
              
              @preference.shipping_methods_long_desc_dom.each do |method_name, value|
                find_or_create_metafield(shopify_api_shop, method_name, value.to_s)                         
              end     
                       
              @preference.temando_shipping_methods_long_desc.each do |method_name, value|
                find_or_create_metafield(shopify_api_shop, method_name, value.to_s)                         
              end                         
          end
      end

      def install
        register_custom_shipping_service        
      end

    end
  end
end
