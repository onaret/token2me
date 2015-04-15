class RemoveCommentFromToken < ActiveRecord::Migration
  def change
    remove_column :tokens, :comment, :integer
  end
end
