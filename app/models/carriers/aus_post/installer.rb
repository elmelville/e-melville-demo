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
          field = ShopifyAPI::Metafield.new({:namespace =>'chief_products',:key=>key_name, :value=>field_value, :value_type=>'string' })
          shopify_api_shop.add_metafield(field)
        end
      end

      def configure(params)
          @preference.shipping_methods_allowed_int = params[:shipping_methods_int].to_h
          @preference.shipping_methods_allowed_dom = params[:shipping_methods_dom].to_h
          @preference.shipping_methods_desc_dom = params[:shipping_methods_desc_dom].to_h
          @preference.shipping_methods_desc_int = params[:shipping_methods_desc_int].to_h
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
