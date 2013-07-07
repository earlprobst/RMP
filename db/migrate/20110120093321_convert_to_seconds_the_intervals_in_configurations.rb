class ConvertToSecondsTheIntervalsInConfigurations < ActiveRecord::Migration
  def self.up
    # Minutes to seconds
    Configuration.all.each do |conf|
      conf.software_update_interval *= 60
      conf.configuration_update_interval *= 60
      conf.status_interval *= 60
      conf.send_data_interval *= 60
      conf.save(:validate => false)
    end
  end

  def self.down
    # Seconds to Minutes
    # Intervals < 1 min. = 1 min.
    Configuration.all.each do |conf|
      conf.software_update_interval > 60 ? conf.software_update_interval /= 60 : 1
      conf.configuration_update_interval > 60 ? conf.configuration_update_interval /= 60 : 1
      conf.status_interval > 60 ? conf.status_interval /= 60 : 1
      conf.send_data_interval > 60 ? conf.send_data_interval /= 60 : 1
      conf.save(:validate => false)
    end
  end
end
