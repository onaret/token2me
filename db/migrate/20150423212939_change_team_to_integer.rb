class ChangeTeamToInteger < ActiveRecord::Migration
  def change
    remove_column :users, :team, :string
    add_column :users, :team, :integer
  end
end
