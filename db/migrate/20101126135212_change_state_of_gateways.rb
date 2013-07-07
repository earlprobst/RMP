class ChangeStateOfGateways < ActiveRecord::Migration
  def self.up
    Gateway.all.each do |gateway|
      if gateway.measurements.present?
        gateway.update_attributes({:state => "installed"})
      end
    end
  end

  def self.down
  end
end
