class AddNotNullToPostsRevealAt < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :reveal_at, false
  end
end
