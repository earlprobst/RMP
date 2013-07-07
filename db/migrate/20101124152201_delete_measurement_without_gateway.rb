class DeleteMeasurementWithoutGateway < ActiveRecord::Migration
  def self.up
    Measurement.all.each {|m| m.destroy if m.medical_device.nil?}
  end

  def self.down
  end
end
