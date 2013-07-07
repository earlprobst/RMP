class RenameLoginToNameInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :login, :name
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can not rollback to the previous version."
  end
end
