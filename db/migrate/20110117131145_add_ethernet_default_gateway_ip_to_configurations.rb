class AddEthernetDefaultGatewayIpToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :ethernet_default_gateway_ip, :string
  end

  def self.down
    remove_column :configurations, :ethernet_default_gateway_ip
  end
end
