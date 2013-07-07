class ChangeDefaultColumns < ActiveRecord::Migration
  def self.up
    change_column :configurations, :time_server_url, :string, :default => nil
    change_column :configurations, :time_zone, :string, :default => nil
    change_column :configurations, :auto_update, :boolean, :default => nil
    change_column :configurations, :send_log_files, :boolean, :default => nil
    change_column :configurations, :state_xml, :string, :default => nil
    change_column :configurations, :gprs_mtu, :integer, :default => nil
  end

  def self.down
    change_column :configurations, :time_server_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/time"
    change_column :configurations, :time_zone, :string, :default => "UTC"
    change_column :configurations, :auto_update, :boolean, :default => false
    change_column :configurations, :send_log_files, :boolean, :default => false
    change_column :configurations, :state_xml, :string, :default => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<modified>true</modified>\n"
    change_column :configurations, :gprs_mtu, :integer, :default => 1500
  end
end
