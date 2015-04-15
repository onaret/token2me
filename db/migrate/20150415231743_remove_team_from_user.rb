class RemoveTeamFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :team, :string
  end
end
