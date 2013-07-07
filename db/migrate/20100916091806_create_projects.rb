class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string    :name
      t.string    :contact_person
      t.string    :email
      t.string    :address
      t.string    :rmp_url
      t.string    :medical_data

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
