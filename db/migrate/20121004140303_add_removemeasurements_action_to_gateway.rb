class AddRemovemeasurementsActionToGateway < ActiveRecord::Migration
  def self.up
    add_column :gateways, :removemeasurements_action, :boolean, :default => false
  end

  def self.down
    remove_column :gateways, :removemeasurements_action
  end
end
