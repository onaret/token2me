class AddColumnIdentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ident, :string
  end
end
