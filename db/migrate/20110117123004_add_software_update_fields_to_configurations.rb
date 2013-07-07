class AddSoftwareUpdateFieldsToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :repo_type, :string
    add_column :configurations, :software_update_interval, :integer

    Configuration.find_each do |c|
      c.repo_type = "stable"
      c.software_update_interval = 1440
      c.save(:validate => false)
    end

    change_column :configurations, :repo_type, :string, :null => false
    change_column :configurations, :software_update_interval, :integer, :null => false
  end

  def self.down
    remove_column :configurations, :repo_type
    remove_column :configurations, :software_update_interval
  end
end
