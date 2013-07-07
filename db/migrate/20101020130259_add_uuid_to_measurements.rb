class AddUuidToMeasurements < ActiveRecord::Migration
  def self.up
    add_column :measurements, :uuid, :string, :limit => 36, :null => false
  end

  def self.down
    remove_column :measurements, :uuid
  end
end
