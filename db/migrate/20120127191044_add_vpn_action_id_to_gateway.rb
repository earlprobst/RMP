class AddVpnActionIdToGateway < ActiveRecord::Migration
  def self.up
    add_column :gateways, :vpn_action_id, :integer
  end

  def self.down
    remove_column :gateways, :vpn_action_id
  end
end
