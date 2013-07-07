class AddTimeZoneToMeasurements < ActiveRecord::Migration
  def self.up
    add_column :measurements, :time_zone, :string
  end

  def self.down
    remove_column :measurements, :time_zone
  end
end
