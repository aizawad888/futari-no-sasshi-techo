class RenamePairColumns < ActiveRecord::Migration[7.2]
  def change
    rename_column :pairs, :user1_id, :user_id1
    rename_column :pairs, :user2_id, :user_id2
  end
end
