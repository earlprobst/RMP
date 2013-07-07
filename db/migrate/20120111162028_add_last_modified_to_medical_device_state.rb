class AddLastModifiedToMedicalDeviceState < ActiveRecord::Migration
  def self.up
    add_column :medical_device_states, :last_modified, :datetime
  end

  def self.down
    remove_column :medical_device_states, :last_modified
  end
end
