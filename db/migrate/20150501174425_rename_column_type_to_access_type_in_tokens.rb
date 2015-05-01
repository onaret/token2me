class RenameColumnTypeToAccessTypeInTokens < ActiveRecord::Migration
  def change
    rename_column :tokens, :type, :access_type
  end
end
