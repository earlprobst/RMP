class AddShutdownActionIdToGateway < ActiveRecord::Migration
  def self.up
    add_column :gateways, :shutdown_action_id, :integer
  end

  def self.down
    remove_column :gateways, :shutdown_action_id
  end
end
