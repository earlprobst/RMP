class AddLocationToGateways < ActiveRecord::Migration
  def self.up
    add_column :gateways, :location, :string
    Gateway.all.each do |gw|
      gw.location = "Set a location"
      gw.save(:validate => false)
    end
  end

  def self.down
    remove_column :gateways, :location
  end
end
