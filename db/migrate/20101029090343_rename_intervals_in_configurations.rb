class RenameIntervalsInConfigurations < ActiveRecord::Migration
  def self.up

    Configuration.find_each do |t|
      t.configuration_update_interval_id = Configuration::INTERVALS.keys[t.configuration_update_interval_id - 1]
      t.status_interval_id = Configuration::INTERVALS.keys[t.status_interval_id - 1]
      t.send_data_interval_id = Configuration::INTERVALS.keys[t.send_data_interval_id - 1]
      t.save(:validate => false)
    end

    rename_column :configurations, :configuration_update_interval_id, :configuration_update_interval
    rename_column :configurations, :status_interval_id, :status_interval
    rename_column :configurations, :send_data_interval_id, :send_data_interval

  end

  def self.down

    rename_column :configurations, :configuration_update_interval, :configuration_update_interval_id
    rename_column :configurations, :status_interval, :status_interval_id
    rename_column :configurations, :send_data_interval, :send_data_interval_id

    Configuration.find_each do |t|
      t.configuration_update_interval_id = Configuration::INTERVALS.keys.index(t.configuration_update_interval_id) + 1
      t.status_interval_id = Configuration::INTERVALS.keys.index(t.status_interval_id) + 1
      t.send_data_interval_id = Configuration::INTERVALS.keys.index(t.send_data_interval_id) + 1
      t.save(:validate => false)
    end
    
  end
end
