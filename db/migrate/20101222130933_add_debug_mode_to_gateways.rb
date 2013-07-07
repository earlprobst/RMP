class AddDebugModeToGateways < ActiveRecord::Migration
  def self.up
    add_column :gateways, :debug_mode, :boolean, :default => false
  end

  def self.down
    remove_column :gateways, :debug_mode
  end
end
