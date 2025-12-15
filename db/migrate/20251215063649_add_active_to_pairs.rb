class AddActiveToPairs < ActiveRecord::Migration[7.2]
  def change
    add_column :pairs, :active, :boolean, default: true, null: false
  end
end
