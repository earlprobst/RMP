class ModifyUrlsInProject < ActiveRecord::Migration
  def self.up
    change_column :projects, :rmp_url, :string, :default => "http://brmp.aentos.net/api/configuration", :null => false
    change_column :projects, :medical_data, :string, :default => "http://brmp.aentos.net/api/measurements.xml", :null => false

    Project.all.each do |project|
      project.update_attributes({:rmp_url => "http://brmp.aentos.net/api/configuration"}) if project.rmp_url.blank?
      project.update_attributes({:medical_data => "http://brmp.aentos.net/api/measurements.xml"}) if project.medical_data.blank?
    end
  end

  def self.down
    change_column :projects, :rmp_url, :string, :null => true
    change_column :projects, :medical_data, :string, :null => true
  end
end
