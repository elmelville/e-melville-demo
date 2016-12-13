class CreatePreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :preference do |t|
      t.string :shop_url
      t.string :origin_postal_code
      t.string :default_weight
      t.integer :height
      t.integer :width
      t.integer :length
      t.float :surcharge_percentage
      t.integer :items_per_box
      t.decimal :default_charge
      t.string :shipping_methods_allowed_int
      t.integer :container_weight
      t.string :shipping_methods_allowed_dom
      t.integer :default_box_size
      t.string :shipping_methods_desc_int
      t.string :shipping_methods_desc_dom
      t.float :surcharge_amount
      t.boolean :hide_welcome_note
      t.string :carrier
      t.boolean :free_shipping_option
      t.string :free_shipping_description
      t.boolean :offers_flat_rate
      t.integer :under_weight
      t.integer :flat_rate
      t.boolean :free_shipping_by_collection
      t.string :shipping_methods_long_desc_int
      t.string :shipping_methods_long_desc_dom
      t.string :rate_lookup_error

      t.timestamps
    end
  end
end