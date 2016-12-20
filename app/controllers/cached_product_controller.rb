class CachedProductController < ShopifyApp::AuthenticatedController
  include ApplicationHelper
  include CarrierHelper

  around_action :shopify_session
  
  layout "application-no-left"

  def index
    @page_title = "Chief Products Shipping Calculator - Products"
    
    @shop = current_shop 
    
    @cached_products = CachedProduct.where(shop_id: @shop.id)

puts 'got prods'
puts @cached_products.inspect
puts 'end'
    size = 0 if @cached_products.nil?
    size = @cached_products.length unless @cached_products.nil?

    # see if there is any new products to be added
    if size == 0
      @shopify_products = update_list

      
      @cached_products = @shopify_products.collect do |p| 
        variants = p.variants.collect.with_index{ |var,i| {('var_'+i.to_s+'_title').to_sym => var.title, ('var_'+i.to_s+'_id').to_sym => var.id, ('var_'+i.to_s+'_large').to_sym => 'unset', ('var_'+i.to_s+'_small').to_sym => 'unset', ('var_'+i.to_s+'_small_count').to_sym => '0', ('var_'+i.to_s+'_length').to_sym => '0', ('var_'+i.to_s+'_width').to_sym => '0', ('var_'+i.to_s+'_height').to_sym => '0', ('var_'+i.to_s+'_cost_adjustment').to_sym => '0'} }.to_json               
        if p.attributes.include? 'id'
          new_prod = CachedProduct.new()
          new_prod.sku = p.variants[0].sku
          new_prod.product_id = p.id.to_s
          new_prod.shop_id = current_shop.id
          new_prod.product_name = p.title
          new_prod.variants = variants
          new_prod.save!
        end
      end
    end 

    @cached_products = CachedProduct.where(shop_id: @shop.id)

  end
  
  def load_new_products
    @shop = current_shop
    
    @shopify_products = update_list 

    #see if there is any new product in @shopify_products
    @shopify_products.each do |sp|
      cp = CachedProduct.find_by_product_id(sp.id.to_s)
      if cp.nil?
        variants = p.variants.collect.with_index{ |var,i| {('var_'+i.to_s+'_title').to_sym => var.title, ('var_'+i.to_s+'_id').to_sym => var.id, ('var_'+i.to_s+'_large').to_sym => 'unset', ('var_'+i.to_s+'_small').to_sym => 'unset', ('var_'+i.to_s+'_small_count').to_sym => '0', ('var_'+i.to_s+'_length').to_sym => '0', ('var_'+i.to_s+'_width').to_sym => '0', ('var_'+i.to_s+'_height').to_sym => '0', ('var_'+i.to_s+'_cost_adjustment').to_sym => '0'} }.to_json               
        p = CachedProduct.new(sku: sp.variants[0].sku, product_id: sp.id.to_s, shop_id:current_shop.id,product_name: sp.title,variants: variants)
        p.save!
      else#check if name has changed
        if (cp.product_name!= sp.title)
          cp.product_name = sp.title
          cp.save
        end
      end
    
    end
    
    #see if there is any product to delete
    products = CachedProduct.find(:all)
    
    products.each do |sp|
      found = false
      @shopify_products.each do |p|
        found = true if p.id.to_s == sp.product_id
      end
      sp.destroy unless found
    end
    flash[:notice] = "saved"
    redirect_to :action=> :index
  end
  
  def update_all
    @shop = current_shop 
    products_to_update = params.require('cached_products').permit(products: [ [:id,:product_id,:shop_id,:sku,:length,:width,:height,:large_item,:small_item,:max_small,:cost_adjustment,
      :var_0_length,:var_0_width,:var_0_height,:var_0_large,:var_0_small,:var_0_small_count,:var_0_cost_adjustment,
      :var_1_length,:var_1_width,:var_1_height,:var_1_large,:var_1_small,:var_1_small_count,:var_1_cost_adjustment,
      :var_2_length,:var_2_width,:var_2_height,:var_2_large,:var_2_small,:var_2_small_count,:var_2_cost_adjustment,
      :var_3_length,:var_3_width,:var_3_height,:var_3_large,:var_3_small,:var_3_small_count,:var_3_cost_adjustment,
      :var_4_length,:var_4_width,:var_4_height,:var_4_large,:var_4_small,:var_4_small_count,:var_4_cost_adjustment,
      :var_5_length,:var_5_width,:var_5_height,:var_5_large,:var_5_small,:var_5_small_count,:var_5_cost_adjustment,
      :var_6_length,:var_6_width,:var_6_height,:var_6_large,:var_6_small,:var_6_small_count,:var_6_cost_adjustment,
      :var_7_length,:var_7_width,:var_7_height,:var_7_large,:var_7_small,:var_7_small_count,:var_7_cost_adjustment,
      :var_8_length,:var_8_width,:var_8_height,:var_8_large,:var_8_small,:var_8_small_count,:var_8_cost_adjustment,
      :var_9_length,:var_9_width,:var_9_height,:var_9_large,:var_9_small,:var_9_small_count,:var_9_cost_adjustment,
      :var_10_length,:var_10_width,:var_10_height,:var_10_large,:var_10_small,:var_10_small_count,:var_10_cost_adjustment] ])  
    @cached_products = products_to_update[:products].to_h
    @cached_products.each do |p|
      id = p[1][:id]
      product = CachedProduct.find(id)
      unless product.nil?
        product.product_id = p[1][:product_id]
        product.shop_id = p[1][:shop_id]
        product.sku = p[1][:sku]
        product.height = p[1][:height]
        product.width = p[1][:width]
        product.length = p[1][:length]
        product.large_item = p[1][:large_item]
        product.small_item = p[1][:small_item]
        product.max_small = p[1][:max_small]
        product.cost_adjustment = p[1][:cost_adjustment]
        variants_hash = JSON.parse(product.variants)
        variants = []
        variants_hash.each_with_index do |variant,i|
          variants.push({('var_'+i.to_s+'_title').to_sym => variant['var_'+i.to_s+'_title'], ('var_'+i.to_s+'_id').to_sym => variant['var_'+i.to_s+'_id'], ('var_'+i.to_s+'_large').to_sym => p[1]['var_'+i.to_s+'_large'], ('var_'+i.to_s+'_small').to_sym => p[1]['var_'+i.to_s+'_small'], ('var_'+i.to_s+'_small_count').to_sym => p[1]['var_'+i.to_s+'_small_count'], ('var_'+i.to_s+'_length').to_sym => p[1]['var_'+i.to_s+'_length'], ('var_'+i.to_s+'_width').to_sym => p[1]['var_'+i.to_s+'_width'], ('var_'+i.to_s+'_height').to_sym => p[1]['var_'+i.to_s+'_height'], ('var_'+i.to_s+'_cost_adjustment').to_sym => p[1]['var_'+i.to_s+'_cost_adjustment']})
        end
        puts 'variants'
        puts variants.to_json      
        product.variants = variants.to_json
        product.save!
      end
    end    
    flash[:notice] = "saved"
    redirect_to :action=> :index
  end
  
  def update_list
    search_params = {:fields=>"id", :limit => false}

    count = ShopifyAPI::Product.count(search_params)        

    page_size = 250
    @total_page = count / page_size
    @total_page = @total_page + 1 if (count % page_size > 0)

    @page = 1 if (@page.to_i > @total_page.to_i)

    fields = "id,title,variants"

    search_params = {:fields=>fields, :limit => page_size}      
    # ppl search_params
    @products = ShopifyAPI::Product.find(:all, :params => search_params)
    # ppl @product
    @variants = {}
    @products.each do |p|
      @variants[p.id] = p.variants
    end
    
    @products = ShopifyAPI::Product.find(:all, :params => search_params)
  end
end