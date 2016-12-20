class CreateCachedProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :cached_products do |t|
      t.string :product_id
      t.integer :shop_id
      t.string :sku
      t.decimal :height
      t.decimal :width
      t.decimal :length
      t.string :product_name
      t.string :large_item
      t.string :small_item
      t.integer :max_small
      t.decimal :cost_adjustment
      t.column :variants, :json

      t.timestamps
    end
  end
end
