class AddColumnCommentToToken < ActiveRecord::Migration
  def change
    add_column :tokens, :comment, :text
  end
end
