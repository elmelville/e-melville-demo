class AddExtrasToShops < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :active_subscriber, :boolean
    add_column :shops, :signup_date, :datetime
    add_column :shops, :charge_id, :string
    add_column :shops, :status, :string
    add_column :shops, :theme_modified, :boolean
    add_column :shops, :version, :integer
    add_column :shops, :domain, :string
  end
end
