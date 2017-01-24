module Carriers
  module AusPost
    class Service < ::Carriers::Service
      def combine_items(items)
        bundles = []
        cached_items = []
        smalls_left = false
        #make list of cached items
        items.each do |line_item|
          item_qty = line_item['quantity'].to_i
          (1..item_qty).each do |qty|
            cached_items.push(line_item)
          end
        end
        #make list of small items from cached items
        cached_items.delete_if do |cached_item|
          temp = CachedProduct.find_by_product_id(cached_item['product_id'].to_s)
          if !temp.blank?
            if temp.small_item == 'small'
              (0..cached_item['quantity']-1).each do |i|
                small_items.push(cached_item)
                smalls_left = true
              end
              true
            end
          end
        end      
        #sort small items ascending by how many will fit with a large item
        def compare(x,y)
          a = CachedProduct.find_by_product_id(x['product_id'].to_s)
          b = CachedProduct.find_by_product_id(y['product_id'].to_s)
          return a.max_small <=> b.max_small
        end
        small_items.sort! { |a,b| compare(a,b) }  
        #create an array of small item @bundles that will bundle together with any available large items
        while smalls_left
          if small_items.length > 0
            small_cached = CachedProduct.find_by_product_id(small_items[0]['product_id'].to_s)
            items_to_bundle = small_cached.max_small
            if small_items.length >= items_to_bundle
              temp_small = []
              (0..items_to_bundle-1).each do |i|
                temp_small.push(small_items.shift(1))      
              end
              bundles[bundle_count] = temp_small
              bundle_count += 1
              smalls_left = small_items.length > 0 ? true : false
            else
              smalls_left = false
            end
          else
            smalls_left = false
          end
        end
        #assign remaining small items into a new bundle
        if small_items.length > 0
          bundles[bundle_count] = small_items
        end    
        #add available large items to bundles if any bundles exist
        if bundles.length > 0
          bundle_count = 0
          cached_items.delete_if do |item|
            large_cached = CachedProduct.find_by_product_id(item['product_id'].to_s)
            if (large_cached.large_item == 'large') && (bundles.length > bundle_count)
              wrapped = [item]
              bundles[bundle_count].unshift(wrapped)
              bundle_count += 1
              true
            end
          end
        end 
        #add remaining items to individual bundles
        cached_items.each do |item|
          wrapped = [item]
          bundles[bundle_count].unshift(wrapped)
          bundle_count += 1
        end
        return bundles
      end
      def fetch_rates   
        puts 'entered auspostbus calc'
        preference = @preference 
        @returned_rates = []
        @order_weight = 0
        #does order have both packages and satchels?
        @mixed_order = false
        @service_counts = {}
        #calculate order weight
        items.each do |line_item|
          item_qty = line_item['quantity'].to_i
          (1..item_qty).each do |qty|
            @order_weight += line_item['grams'].to_i
          end
        end        
        items.each do |item|
          current_id = item["product_id"].to_s
          cached_item = CachedProduct.find_by(product_id: current_id)
          item_height = 0.0
          item_width = 0.0
          item_length = 0.0
          price_adjustment = 0.0
          #set dimensions and return empty list if item has no dimensions
          if cached_item
            if cached_item.height != 0.0
              item_height = cached_item.height || 0
            end
            if cached_item.width != 0.0
              item_width = cached_item.width || 0
            end
            if cached_item.length != 0.0
              item_length = cached_item.length || 0
            end  
            price_adjustment = cached_item.cost_adjustment.to_f                      
          end
          puts 'post easure info'
          puts item.inspect
          puts cached_item.inspect
          puts item_height
          puts item_width
          puts item_length          
          if item_height > 105 or item_width > 105 or item_length > 105
            @returned_rates = []
            @service_list = {}
            break
          else
            #use to return inavlid item name
            if item_height == 0.0 && item_width == 0.0 && item_length == 0.0
              puts 'invalid item dimensions'
              @service_list = {}
  #            @service_list.append({ service_name: "Invalid Item - " + item[:name],
  #                           service_code: item[:name],
  #                           total_price: preference.default_charge * 100,
  #                           currency: "AUD"})
              return @service_list
            end       
            puts '1'  
            @australia_post_api_connection = AustraliaPostApiConnection.new({
              from_postcode: preference.origin_postal_code,
              height: item_height,
              width: item_width,
              length: item_length
            }) 
            puts '2'       
            quan = 0
            weight = 0

            # get the items weight

            quan = item["quantity"].to_i    
            weight = item["grams"].to_i if (item["requires_shipping"])  

            calculated_weight = weight
            rate_list = Array.new
puts '3'  
            if (preference.offers_flat_rate)                            
             if (calculated_weight <= preference.under_weight)
               rate_list << { service_name: "Shipping",
                             service_code: "Shipping",
                             total_price: (preference.flat_rate * 100).to_s,
                             currency: "AUD"}
               return
             end
            end
            puts '4'
            if (preference.free_shipping_by_collection)
             subtract_weight = 0

             #get free shipping items weight and subtract total weight.

             app_shop = self.shop

             ShopifyAPI::Session.temp(app_shop.myshopify_domain, app_shop.token) do         
               p = ShopifyAPI::Product.find(item["product_id"].to_i)

               p.collections.each do |col|
                 fields = col.metafields
                 field = fields.find { |f| f.key == 'free_shipping' && f.namespace ='AusPostShipping'}
                 unless field.nil?
                   subtract_weight += item["grams"] if field.value.to_s == "true"
                 end
               end

               p.smart_collections.each do |col|
                 fields = col.metafields
                 field = fields.find { |f| f.key == 'free_shipping' && f.namespace ='AusPostShipping'}
                 
                 unless field.nil?
                   subtract_weight +=  item["grams"] if field.value.to_s == "true"
                 end
               end
             end

             calculated_weight = calculated_weight.to_f - subtract_weight

            end
            puts '5'           
            # in grams, convert to kg
            if (calculated_weight.to_f == 0.0)
             #no need to call australia post. no weight of item
              @service_list = Array.new
              @service_list.append({ service_name: "Free Shipping",
                             service_code: "Free Shipping",
                             total_price: "0.0",
                             currency: "AUD"})               

              return @service_list
            end
puts 'destination params'
puts params.inspect
            calculated_weight = calculated_weight.to_f / 1000              
            @australia_post_api_connection = AustraliaPostApiConnection.new({:weight=> calculated_weight,
                                                                           :from_postcode => preference.origin_postal_code,
                                                                           :country_code =>  params[:destination]['country'].to_s,
                                                                           :to_postcode => params[:destination]['postal_code'].to_s,
                                                                           :height=>item_height, :width=>item_width, :length=>item_length,
                                                                           :container_weight => preference.container_weight
            })
            @australia_post_api_connection.domestic = ( params[:destination]['country'].to_s == "AU" )

            # get country list from the API -- we'll format these if there were no errors
            @service_list = @australia_post_api_connection.data_oriented_methods(:service) # get the service list

            if @australia_post_api_connection.domestic
             shipping_methods = preference.shipping_methods_allowed_dom
             shipping_desc = preference.shipping_methods_desc_dom
            else
             shipping_methods = preference.shipping_methods_allowed_int
             shipping_desc = preference.shipping_methods_desc_int
            end

            aus_list = @service_list[1]['service']

            has_satchel = false

            aus_list.each do |l|
              has_satchel = l['code'].include?("SATCHEL_") || has_satchel         
            end
            @mixed_order = @mixed_order || has_satchel

            if @australia_post_api_connection.save
             @service_list = Array.wrap( @service_list[1]['service'] ).inject([]) do |list, service|
              code_string = service['code'].to_s
              has_satchel_is_satchel = has_satchel && code_string.include?("SATCHEL_")
               if shipping_methods[service['code']]
                 if ( has_satchel == false || has_satchel_is_satchel )
                   price_to_charge = service['price'].to_f - price_adjustment
                   price_to_carge = price_to_charge > 0.0 ? price_to_charge : 0.0
                   shipping_name = shipping_desc[service['code']].blank? ? service['name'] : shipping_desc[service['code']]
                   unless preference.nil?
                     unless preference.surcharge_percentage.nil?
                       if preference.surcharge_percentage > 0.0
                         price_to_charge =(price_to_charge * (1 + preference.surcharge_percentage/100)).round(2)
                       end
                     end

                     unless preference.surcharge_amount.nil?
                       if preference.surcharge_amount > 0.0
                         price_to_charge = (price_to_charge + preference.surcharge_amount).round(2)
                       end
                     end
                   end
                    #adjust for qty
                    price_to_charge = price_to_charge * quan
                    rate_not_found = true
                    @returned_rates.each do |rate|
                      if shipping_name == rate[:service_name]
                        rate[:total_price] = rate[:total_price].to_f + price_to_charge.to_f * 100
                        rate_not_found = false
                      end
                    end
                   if rate_not_found
                     @returned_rates.append({ service_name: shipping_name,
                                 service_code: service['code'],
                                 total_price: price_to_charge * 100, # return price in cents
                                 currency: "AUD"})        
                   end
                   if @service_counts.key?(service['code'].to_s)
                    @service_counts[service['code'].to_s] = @service_counts[service['code'].to_s] + 1
                   else
                    @service_counts[service['code'].to_s] = 1
                   end
                 end
               end # if shipping_methods[service['code']]
               list
            end       

             # check if need to add free shipping option
             if (preference.free_shipping_option)
                @service_list.append({ service_name: preference.free_shipping_description,
                             service_code: "Free",
                             total_price: "0.00",
                              currency: "AUD"})
                @returned_rates.append({ service_name: preference.free_shipping_description,
                             service_code: "Free",
                             total_price: "0.00",
                              currency: "AUD"})                
             end
            end
          end
          #combine satchel and package rates for mixed domestic orders
          if @mixed_order
            if @australia_post_api_connection.domestic
              total_regular = 0
              total_express = 0
              @returned_rates.each do |rate|
                if rate[:service_code].include?("PARCEL_REGULAR")
                  total_regular = total_regular + rate[:total_price].to_f
                end
                if rate[:service_code].include?("PARCEL_EXPRESS")
                  total_express = total_regular + rate[:total_price].to_f
                end            
              end
              @returned_rates = [{
                service_name: 'Parcel Post',
                service_code: 'AUS_PARCEL_REGULAR',
                total_price: total_regular.to_s,
                currency: 'AUD'
              },{
                service_name: 'Express Post',
                service_code: 'AUS_PARCEL_EXPRESS',
                total_price: total_express.to_s,
                currency: 'AUD'
              }] 
            else
              total_cor = 0
              total_exp = 0
              total_std = 0
              total_air = 0
              total_sea = 0
              @returned_rates.each do |rate|
                if rate[:service_code].include?("_COR_")
                  total_cor = total_cor + rate[:total_price]
                end 
                if rate[:service_code].include?("_EXP_")
                  total_exp = total_exp + rate[:total_price]
                end 
                if rate[:service_code].include?("_STD_")
                  total_std = total_std + rate[:total_price]
                end 
                if rate[:service_code].include?("_AIR_")
                  total_air = total_air + rate[:total_price]
                end 
                if rate[:service_code].include?("_SEA_")
                  total_sea = total_sea + rate[:total_price]
                end                                                                           
              end
              @returned_rates = []
              if total_cor > 0
                @returned_rates.push({
                  service_name: 'Express Courier International',
                  service_code: 'INT_PARCEL_COR_OWN_PACKAGING',
                  total_price: total_cor.to_s,
                  currency: 'AUD'                    
                })
              end
              if total_exp > 0
                @returned_rates.push({
                  service_name: 'Express Post International',
                  service_code: 'INT_PARCEL_EXP_OWN_PACKAGING',
                  total_price: total_exp.to_s,
                  currency: 'AUD'                    
                })
              end
              if total_std > 0
                @returned_rates.push({
                  service_name: 'International Standard Post',
                  service_code: 'INT_PARCEL_STD_OWN_PACKAGING',
                  total_price: total_std.to_s,
                  currency: 'AUD'                    
                })
              end
              if total_air > 0
                @returned_rates.push({
                  service_name: 'Air Mail',
                  service_code: 'INT_PARCEL_AIR_OWN_PACKAGING',
                  total_price: total_air.to_s,
                  currency: 'AUD'                    
                })
              end
              if total_sea > 0
                @returned_rates.push({
                  service_name: 'Sea Mail',
                  service_code: 'INT_PARCEL_COR_OWN_PACKAGING',
                  total_price: total_sea.to_s,
                  currency: 'AUD'                    
                })
              end
            end     
          end
          #check for rates that only fit a single item in cart
          if !@australia_post_api_connection.domestic
            @all_int_rates = @returned_rates
            @returned_rates = []
            @all_int_rates.each_with_index do |int_service,index|
              if @service_counts[int_service[:service_code]] == items.length
                @returned_rates.append(@all_int_rates[index])
              end
            end 
          end  
        end
          puts 'all rates'
          puts @returned_rates.inspect
         @service_list
         @returned_rates
      end   #end def fetch_rates
    end    
  end
end