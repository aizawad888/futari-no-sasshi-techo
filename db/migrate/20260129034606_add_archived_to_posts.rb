class AddArchivedToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :archived, :boolean, default: false, null: false
  end
end
