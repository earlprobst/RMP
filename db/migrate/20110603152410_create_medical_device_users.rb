class CreateMedicalDeviceUsers < ActiveRecord::Migration
  def self.up
    create_table :medical_device_users do |t|
      t.integer :medical_device_id
      t.integer :md_user  # 1 - 8
      t.string :gender # male | female
      t.integer :physical_activity # low | average | intensive
      t.integer :age
      t.decimal :height
      t.integer :units # kg-cm | lb-inch | st-inch
      t.boolean :display_body_fat
      t.boolean :display_body_water
      t.boolean :display_muscle_mass
      t.boolean :default

      t.timestamps
    end
  end

  def self.down
    drop_table :medical_device_users
  end
end
