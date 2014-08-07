class RenameTypeColumnInTickets < ActiveRecord::Migration
  def change
    rename_column :tickets, :type, :wager_type
  end
end
