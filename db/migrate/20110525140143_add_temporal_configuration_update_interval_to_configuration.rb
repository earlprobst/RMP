class AddTemporalConfigurationUpdateIntervalToConfiguration < ActiveRecord::Migration
  def self.up
    add_column :configurations, :temporal_configuration_update_interval, :integer
  end

  def self.down
    remove_column :configurations, :temporal_configuration_update_interval
  end
end
