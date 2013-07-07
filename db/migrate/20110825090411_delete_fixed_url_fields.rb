class DeleteFixedUrlFields < ActiveRecord::Migration
  def self.up
    remove_column :projects, :system_state_update_url
    remove_column :projects, :configuration_state_url
    remove_column :projects, :log_url
    remove_column :configurations, :time_server_url
    change_column :projects, :rmp_url, :string, :default => "https://#{APP_CONFIG[:host]}/api", :null => false
    update "update projects set rmp_url = 'https://#{APP_CONFIG[:host]}/api'"
  end

  def self.down
    add_column :projects, :log_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/log_files", :null => false
    add_column :projects, :configuration_state_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/configuration/state", :null => false
    add_column :projects, :system_state_update_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/system_states.xml", :null => false
    add_column :configurations, :time_server_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/time", :null => false
    change_column :projects, :rmp_url, :string, :default => "https://#{APP_CONFIG[:host]}/api/configuration", :null => false
    update "update projects set rmp_url = 'https://#{APP_CONFIG[:host]}/api/configuration'"
  end
end
