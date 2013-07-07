class DeleteNotNullFromIdColumns < ActiveRecord::Migration
  def self.up
    change_column :log_files, :gateway_id, :integer, :null => true
    change_column :system_states, :gateway_id, :integer, :null => true
    change_column :measurements, :medical_device_id, :integer, :null => true
  end

  def self.down
    change_column :log_files, :gateway_id, :integer, :null => false
    change_column :system_states, :gateway_id, :integer, :null => false
    change_column :measurements, :medical_device_id, :integer, :null => false
  end
end
