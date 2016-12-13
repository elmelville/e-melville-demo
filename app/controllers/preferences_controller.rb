class PreferencesController < ShopifyApp::AuthenticatedController

  include ApplicationHelper
  include CarrierHelper

  around_action :shopify_session
  #before_action :check_payment
  layout "application-no-left"



  def show
    @page_title = "Chief Products Shipping Calculator - Settings"
    @preference = get_preference
    @preference.carrier = 'aus_post'
    @carrier_preference = get_carrier_preference(@preference.carrier)
    @free_shipping_options = get_collection_shipping_options
    
    if (@preference.carrier == "chief_products")
      @hide_carrier_setting = true
    else
       @hide_carrier_setting = false
    end
    respond_to do |format|
      format.html { render :action => "edit"}
      format.json { render json: @preference }
    end
  end

  # GET /preference/edit
  def edit
    
    @page_title = "Chief Products Shipping Calculator - Settings"
    @preference = get_preference
    @carrier_preference = get_carrier_preference(@preference.carrier)
    
    @free_shipping_options = get_collection_shipping_options
    if (@preference.carrier == "chief_products")
      @hide_carrier_setting = true
    else
       @hide_carrier_setting = false
    end
    
  end

  # PUT /preference
  # PUT /preference
  def update
    
    @preference = get_preference()

    @preference.shop_url = session[:shopify_domain].to_s

    @preference[:shipping_methods_long_desc_int] = params[:shipping_methods_long_desc_int].to_h
    @preference[:shipping_methods_long_desc_dom] = params[:shipping_methods_long_desc_dom].to_h
    @preference.save

    shopify_api_shop = ShopifyAPI::Shop.current                           
    
    params[:shipping_methods_long_desc_int].each do |method_name, value|
      find_or_create_metafield(shopify_api_shop, method_name, value.to_s)                     
    end
    
    params[:shipping_methods_long_desc_dom].each do |method_name, value|
      find_or_create_metafield(shopify_api_shop, method_name, value.to_s)                        
    end
                  

    respond_to do |format|
      @preference.attributes = preference_params
      @carrier_preference = get_carrier_preference(@preference.carrier)
      
      #get free shipping option
    if @preference.free_shipping_by_collection
      colls = ShopifyAPI::CustomCollection.find(:all)

      colls.each do |col|
        free_shipping = (params["#{col.title}"] == "1")
        
         update_coll_metafield(col, free_shipping)
       end

       colls = ShopifyAPI::SmartCollection.find(:all)
       colls.each do |col|
         free_shipping = params["#{col.title}"] == "1"
         
         update_coll_metafield(col, free_shipping)
        end
      end
      installer_class = carrier_installer_class_for('aus_post')
      installer = installer_class.new( session[:shopify_domain], @preference)
      installer.port = request.port if Rails.env.development?
      installer.configure(params)

      if @preference.save
        #save carrier preference
        unless params[:carrier_preference].nil?
          @carrier_preference.attributes = params[:carrier_preference]        
          @carrier_preference.shop_url = @preference.shop_url
        
          @carrier_preference.save
        end
        installer.install

        format.html { redirect_to preferences_url, notice: 'Preference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def carrier_selected
    @preference = get_preference
    @carrier_preference = get_carrier_preference(params[:carrier])

    @free_shipping_options = get_collection_shipping_options
    
    if (params[:carrier].blank?)
      render :text => ""
    else
      render :partial => carrier_partial_for( params[:carrier] )
    end
  end
  
  def shipping_by_collection_selected    
    options = get_collection_shipping_options()
    render :json => shipping_options
  end
  
  

  def hide_welcome_note
    @preference = get_preference 
    @preference.hide_welcome_note = true
    @preference.save
    render :json =>{:result => "ok"}
  end

  private
  
  def update_coll_metafield(col, free_shipping)
    fields = col.metafields
    field = fields.find { |f| f.key == 'free_shipping' && f.namespace ='AusPostShipping'}
    if field.nil?              
      field = ShopifyAPI::Metafield.new({:namespace =>'AusPostShipping',:key=>'free_shipping', :value=>free_shipping.to_s, :value_type=>'string' })
    else
      field.destroy
      field = ShopifyAPI::Metafield.new({:namespace =>'AusPostShipping',:key=>'free_shipping', :value=>free_shipping.to_s, :value_type=>'string' })
    end
    col.add_metafield(field)
  end

  def find_or_create_metafield(shopify_api_shop, key_name, field_value)
    found = shopify_api_shop.metafields.select {|m| m.key == key_name}            
    if (found.length > 0)
      if (found[0].value.to_s != field_value)
        #puts("found[0] is #{found[0]}")
        found[0].value = field_value    
        shopify_api_shop.add_metafield(found[0])            
      end                       
    else
      field = ShopifyAPI::Metafield.new({:namespace =>'chief_products',:key=>key_name, :value=>field_value, :value_type=>'string' })
      shopify_api_shop.add_metafield(field)
    end
  end  
  
  def get_coll_free_shipping(col)
    free_shipping = false    
    fields = col.metafields
    
    field = fields.find { |f| f.key == 'free_shipping' && f.namespace ='AusPostShipping'}
    unless field.nil?
      free_shipping = (field.value == "true")
    end
    free_shipping
  end

  def get_collection_shipping_options
    colls = ShopifyAPI::CustomCollection.find(:all)
    
    shipping_options = Array.new
    
    colls.each do |col|
       free_shipping = get_coll_free_shipping(col)
       shipping_options << {:collection_name => col.title, :free => free_shipping, :collection_id => col.id}
     end
     
     colls = ShopifyAPI::SmartCollection.find(:all)
     colls.each do |col|
        free_shipping = get_coll_free_shipping(col)
        shipping_options << {:collection_name => col.title, :free => free_shipping, :collection_id => col.id}
      end
           
    shipping_options
  end

  def get_preference
    puts 'pref retrieve'
    puts current_shop.inspect
    preference = Preference.find_by_shop(current_shop)   
    puts 'pref found'
    puts preference.inspect 
    preference ||= Preference.new
  end
  
  def preference_params
    params.require(:preference).permit(:origin_postal_code, :default_weight, :surcharge_percentage, :surcharge_amount, :height, :width, :length, :items_per_box, :default_charge, :shipping_methods_allowed_dom, :default_box_size,
      :shipping_methods_allowed_int, :container_weight, :shipping_methods_desc_int, :shipping_methods_desc_dom,:shipping_methods_long_desc_int, :shipping_methods_long_desc_dom, :shop_url, :carrier, 
      :free_shipping_option, :free_shipping_description, :offers_flat_rate, :under_weight, :flat_rate,:free_shipping_by_collection)
  end

  def get_carrier_preference(carrier)
    begin
      unless carrier.nil?
        pre_class = carrier_preference_for(carrier)
        preference = pre_class.find_by_shop(current_shop)
        preference ||= pre_class.new
      else
        nil
      end  
    rescue
      return nil
    end
  end
end
