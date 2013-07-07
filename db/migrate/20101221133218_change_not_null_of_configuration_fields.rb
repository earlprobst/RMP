class ChangeNotNullOfConfigurationFields < ActiveRecord::Migration
  def self.up
    (1..3).entries.each { |n| change_column :configurations, "network_#{n}_id".to_sym, :integer, :null => true }
    change_column :configurations, :ethernet_ip_assignment_method_id, :integer, :null => true
    change_column :configurations, :gprs_provider, :string, :null => true
    change_column :configurations, :gprs_apn, :string, :null => true
    change_column :configurations, :gprs_mtu, :integer, :null => true
  end

  def self.down
    (1..3).entries.each { |n| change_column :configurations, "network_#{n}_id".to_sym, :integer, :null => false }
    change_column :configurations, :ethernet_ip_assignment_method_id, :integer, :null => false
    change_column :configurations, :gprs_provider, :string, :null => false
    change_column :configurations, :gprs_apn, :string, :null => false
    change_column :configurations, :gprs_mtu, :integer, :null => false
  end
end
