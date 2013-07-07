class RenameMedicalDataToMedicalDataUrlInProjects < ActiveRecord::Migration
  def self.up
    rename_column :projects, :medical_data, :medical_data_url
  end

  def self.down
    rename_column :projects, :medical_data_url, :medical_data
  end
end
