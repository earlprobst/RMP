class ChangeDefaultsUrLs < ActiveRecord::Migration
  def self.up
    change_column :projects, :rmp_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/configuration", :null => false
    change_column :projects, :medical_data_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/measurements.xml", :null => false
    change_column :projects, :log_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/log_files", :null => false
    change_column :projects, :configuration_state_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/configuration/state", :null => false
    change_column :projects, :system_state_update_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/system_states.xml", :null => false
    change_column :configurations, :time_server_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/time", :null => false
  end

  def self.down
    change_column :projects, :rmp_url, :string, :default => "https://brmp.aentos.net/api/configuration", :null => false
    change_column :projects, :medical_data_url, :string, :default => "https://brmp.aentos.net/api/measurements.xml", :null => false
    change_column :projects, :log_url, :string, :default => "https://brmp.aentos.net/api/log_files", :null => false
    change_column :projects, :configuration_state_url, :string, :default => "https://brmp.aentos.net/api/configuration/state", :null => false
    change_column :projects, :system_state_update_url, :string, :default => "https://brmp.aentos.net/api/system_states.xml"
    change_column :configurations, :time_server_url, :string, :default => "https://brmp.aentos.net/api/time", :null => false
  end
end
