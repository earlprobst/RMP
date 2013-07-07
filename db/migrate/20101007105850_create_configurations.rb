class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.belongs_to :gateway
      (1..3).entries.each { |n| t.integer "network_#{n}_id".to_sym, :null => false }

      t.integer    :ethernet_ip_assignment_method_id, :null => false
      t.string     :ethernet_ip
      t.integer    :ethernet_mtu
      t.string     :gprs_provider,                    :null => false
      t.string     :gprs_apn,                         :null => false
      t.integer    :gprs_mtu,                         :null => false
      t.integer    :configuration_update_interval_id, :null => false
      t.integer    :status_interval_id,               :null => false
      t.integer    :send_data_interval_id,            :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
