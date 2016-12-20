class RatesController < ApplicationController
  include CarrierHelper


  def shipping_rates 
  puts 'does this trigger'
  puts 'header'
  puts request.headers['X-CSRF-Token'].inspect
  puts request.headers['rate'].inspect
    preference = get_shop_prefence_from_request


   # log_params
   puts 'params are'
   puts params.inspect
   puts params.permitted?
    top_level = params.require('rate').permit('shop_url','controller','action','origin', 'destination', 'items')
   puts top_level.inspect
   puts top_level['origin']
   puts top_level['origin']['province']
    return nothing unless params[:rate] && preference
    puts ("---- Received rate request " + params.to_s)
    service_class = carrier_service_class_for(preference.carrier)
    service = service_class.new(preference, params[:rate])
    rates = service.fetch_rates
    if rates == {}
      render nothing: true
    else
      render :json => {:rates => rates}
    end
  end

  private
  
  def get_shop_prefence_from_request()
    shop_domain = get_shop_domain_from_request
    shop = Shop.find_by_url(shop_domain)
    preference = Preference.find_by_shop(shop)
    preference
  end
  
  def get_shop_domain_from_request
    request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']
  end
  
  def log_params    
    Rails.logger.debug("shipping origin is" + params[:rate][:origin].to_s)
    Rails.logger.debug("shipping destination is" + params[:rate][:destination].to_s)
    Rails.logger.debug("shipping items is" + params[:rate][:items].to_s)
  end

  def nothing
    render nothing: true
  end

  protected

  def set_csrf_headers
    if request.xhr?
      # Add the newly created csrf token to the page headers
      # These values are sent on 1 request only
      response.headers['X-CSRF-Token'] = "#{form_authenticity_token}"
      response.headers['X-CSRF-Param'] = "#{request_forgery_protection_token}"
    end
  end
end
