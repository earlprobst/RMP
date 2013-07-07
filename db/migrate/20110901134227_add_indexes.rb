class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :activities_dates, :gateway_id
    add_index :configurations, :gateway_id
    add_index :gateways, :project_id
    add_index :log_files, :gateway_id
    add_index :measurements, :medical_device_id
    add_index :medical_device_states, :system_state_id
    add_index :medical_device_users, :medical_device_id
    add_index :medical_devices, :gateway_id
    add_index :project_users, :project_id
    add_index :project_users, :user_id
    add_index :system_states, :gateway_id
    # Find_by...
    add_index :gateways, :token
    add_index :measurements, :uuid
    add_index :users, :email
  end

  def self.down
    remove_index :activities_dates, :gateway_id
    remove_index :configurations, :gateway_id
    remove_index :gateways, :project_id
    remove_index :log_files, :gateway_id
    remove_index :measurements, :medical_device_id
    remove_index :medical_device_states, :system_state_id
    remove_index :medical_device_users, :medical_device_id
    remove_index :medical_devices, :gateway_id
    remove_index :project_users, :project_id
    remove_index :project_users, :user_id
    remove_index :system_states, :gateway_id
    remove_index :gateways, :token
    remove_index :measurements, :uuid
    remove_index :users, :email
  end
end
