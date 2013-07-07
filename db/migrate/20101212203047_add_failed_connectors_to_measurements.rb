class AddFailedConnectorsToMeasurements < ActiveRecord::Migration
  def self.up
    add_column :measurements, :failed_connectors_mask, :integer
  end

  def self.down
    remove_column :measurements, :failed_connectors_mask
  end
end
