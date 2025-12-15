class ChangePairIdNullOnPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :pair_id, true
  end
end
