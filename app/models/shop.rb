class Shop < ActiveRecord::Base

	include ShopifyApp::Shop
	include ShopifyApp::SessionStorage
	has_many :cached_products
	has_many :orders

  def self.find_by_url(url)
    shop = Shop.arel_table
    Shop.where(
      shop[:shopify_domain].eq(url).
      or(
      shop[:domain].eq(url))
    ).first
  end

end
