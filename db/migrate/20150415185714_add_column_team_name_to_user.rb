class AddColumnTeamNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :team, :string
    add_column :users, :name, :string
  end
end
