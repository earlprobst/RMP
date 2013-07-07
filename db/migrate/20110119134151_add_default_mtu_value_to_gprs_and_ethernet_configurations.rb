class AddDefaultMtuValueToGprsAndEthernetConfigurations < ActiveRecord::Migration
  def self.up
    change_column :configurations, :gprs_mtu, :integer, :default => 1500
  end

  def self.down
    change_column :configurations, :gprs_mtu, :integer, :default => nil
  end
end
