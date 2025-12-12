class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pair, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :title
      t.datetime :reveal_at
      t.integer :sense_level

      t.timestamps
    end
  end
end
