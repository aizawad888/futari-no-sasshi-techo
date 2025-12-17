class CreatePostMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :post_memos do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :memo

      t.timestamps
    end
  end
end
