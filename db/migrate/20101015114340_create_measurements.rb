class CreateMeasurements < ActiveRecord::Migration
  def self.up
    create_table :measurements do |t|
      t.belongs_to  :medical_device,        :null => false
      t.string      :type,                  :null => false
      t.integer     :session_id,            :null => false
      t.datetime    :measured_at,           :null => false

      t.boolean     :transmitted_data_set,  :null => false
      t.integer     :user,                  :null => false
      t.datetime    :registered_at,         :null => false

      t.integer     :systolic
      t.integer     :diastolic
      t.integer     :pulse

      t.integer     :glucose

      t.decimal     :weight
      t.decimal     :impedance
      t.decimal     :body_fat
      t.decimal     :body_water
      t.decimal     :muscle_mass

      t.timestamps
    end
  end

  def self.down
    drop_table :measurements
  end
end
