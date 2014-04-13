class AddRetinaToPost < ActiveRecord::Migration
  def change
    add_column :posts, :retina, :boolean, default: :false
  end
end
