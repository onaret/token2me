class AddTypeToToken < ActiveRecord::Migration
  def change
    add_column :tokens, :type, :int
  end
end
