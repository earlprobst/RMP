class CreateMedicalDeviceStates < ActiveRecord::Migration
  def self.up
    create_table :medical_device_states do |t|
      t.belongs_to  :system_state,                    :null => false
      t.string      :medical_device_serial_number,    :null => false
      t.string      :connection_state
      t.integer     :error_id
      t.boolean     :bounded
      t.boolean     :low_battery
      t.boolean     :on_time

      t.timestamps
    end

    remove_column :medical_devices, :bounded
    remove_column :medical_devices, :in_time
    remove_column :medical_devices, :low_battery
  end

  def self.down
    drop_table :medical_device_states

    add_column :medical_devices, :bounded, :boolean, :default => false
    add_column :medical_devices, :in_time, :boolean, :default => false
    add_column :medical_devices, :low_battery, :boolean, :default => false
  end
end
