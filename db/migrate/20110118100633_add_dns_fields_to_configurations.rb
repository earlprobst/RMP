class AddDnsFieldsToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :ethernet_dns_1, :string
    add_column :configurations, :ethernet_dns_2, :string
  end

  def self.down
    remove_column :configurations, :ethernet_dns_1
    remove_column :configurations, :ethernet_dns_2
  end
end
