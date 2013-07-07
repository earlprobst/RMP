class RenameOnTimeToDateInMedicalDeviceStates < ActiveRecord::Migration
  def self.up
    remove_column :medical_device_states, :on_time
    add_column :medical_device_states, :date, :datetime
  end

  def self.down
    remove_column :medical_device_states, :date
    add_column :medical_device_states, :on_time, :boolean
  end
end
