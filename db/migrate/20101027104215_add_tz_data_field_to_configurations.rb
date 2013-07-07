class AddTzDataFieldToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :tz_data, :string

    Configuration.find_each do |c|
      c.save!(:validate => false)
    end
  end

  def self.down
    remove_column :configurations, :tz_data
  end
end
