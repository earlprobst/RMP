class CreateMedicalDevices < ActiveRecord::Migration
  def self.up
    create_table :medical_devices do |t|
      t.belongs_to :gateway,                :null => false
      t.string    :serial_number,           :null => false
      t.integer   :type_id,                 :null => false
      t.integer   :number_of_users,         :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :medical_devices
  end
end
