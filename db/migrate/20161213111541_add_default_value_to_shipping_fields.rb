class AddDefaultValueToShippingFields < ActiveRecord::Migration[5.0]
  def change
  end
	def up
	  change_column :preferences, :shipping_methods_long_desc_int, :string, :default => ''
	  change_column :preferences, :shipping_methods_long_desc_dom, :string, :default => ''
	  change_column :preferences, :shipping_methods_desc_int, :string, :default => ''
	  change_column :preferences, :shipping_methods_desc_dom, :string, :default => ''
	  change_column :preferences, :shipping_methods_allowed_int, :string, :default => ''
	  change_column :preferences, :shipping_methods_allowed_dom, :string, :default => ''
	end

	def down
	  change_column :preferences, :shipping_methods_long_desc_int, :string, :default => nil
	  change_column :preferences, :shipping_methods_long_desc_dom, :string, :default => nil
	  change_column :preferences, :shipping_methods_desc_int, :string, :default => nil
	  change_column :preferences, :shipping_methods_desc_dom, :string, :default => nil
	  change_column :preferences, :shipping_methods_allowed_int, :string, :default => nil
	  change_column :preferences, :shipping_methods_allowed_dom, :string, :default => nil
	end  
end          