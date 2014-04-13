class ChangeColumnToPost < ActiveRecord::Migration
  def change
    remove_column :posts, :comment_status
    add_column :posts, :comment_status, :boolean, default: false
  end
end
