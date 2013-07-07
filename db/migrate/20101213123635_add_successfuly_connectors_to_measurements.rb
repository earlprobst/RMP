class AddSuccessfulyConnectorsToMeasurements < ActiveRecord::Migration
  def self.up
    add_column :measurements, :successfuly_connectors_mask, :integer
  end

  def self.down
    remove_column :measurements, :successfuly_connectors_mask
  end
end
