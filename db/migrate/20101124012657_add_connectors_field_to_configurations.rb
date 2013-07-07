class AddConnectorsFieldToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :connectors_mask, :integer
  end

  def self.down
    remove_column :configurations, :connectors_mask
  end
end
