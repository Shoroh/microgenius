class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.datetime :post_date
      t.string :post_title
      t.text :post_content
      t.string :post_status
      t.string :comment_status
      t.string :post_name
      t.string :post_type

      t.timestamps
    end
  end
end
