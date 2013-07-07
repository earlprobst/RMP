class ModifyTokenInGateways < ActiveRecord::Migration
  def self.up
    change_column :gateways, :token, :string, :null => true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can not rollback to the previous version."
  end
end
