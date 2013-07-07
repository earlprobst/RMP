class ModifiedConfigurationStateUrl < ActiveRecord::Migration
  def self.up
    Project.all.each do |p|
      p.configuration_state_url = "https://brmp.aentos.net/api/configuration/state"
      p.save
    end
  end

  def self.down
    Project.all.each do |p|
      p.configuration_state_url = "http://brmp.aentos.net/api/configuration/state"
      p.save
    end
  end
end
