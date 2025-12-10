class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    add_column :users, :sex, :string
    add_column :users, :icon, :string
    add_column :users, :pair_id, :bigint
    add_column :users, :my_code, :string
    add_index :users, :my_code, unique: true
    add_column :users, :partner_code, :string
  end
end
