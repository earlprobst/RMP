class ExtractMedicalDeviceUsers < ActiveRecord::Migration
  def self.up

    rename_column :medical_devices, :default_user, :md_default_user

    begin
      MedicalDevice.find_each do |md|
        users = (1..8).reject { |u| ((md.users_mask || 0) & 2**u).zero? }
        users.each do |u|
          MedicalDeviceUser.create(:medical_device => md, :md_user => u, :default => (md.md_default_user == u))
        end
      end
    rescue Exception => e
      puts "Exception => #{e}"
    end

    remove_column :medical_devices, :users_mask
    remove_column :medical_devices, :md_default_user
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Irreversible migration"
  end
end
