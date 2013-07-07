class CreateProjectUsers < ActiveRecord::Migration
  def self.up
    create_table :project_users do |t|
      t.integer     :project_id,  :null => false
      t.integer     :user_id,     :null => false
      t.string      :role,        :null => false

      t.timestamps
    end

    add_column :users, :superadmin, :boolean

    User.reset_column_information
    User.find_each do |u|
      if u.role == "admin"
        u.update_attribute(:superadmin, true)
      else
        if u.role == "user"
          Project.find_each do |p|
            p_r = ProjectUser.new
            p_r.project_id = p.id
            p_r.user_id = u.id
            p_r.role = "user"
            p_r.save!(:validate => false)
          end
        else
          p_r = ProjectUser.new
          p_r.project_id = u.project_id
          p_r.user_id = u.id
          p_r.role = (u.role == "project_admin") ? "admin" : "user"
          p_r.save!(:validate => false)
          u.update_attribute(:superadmin, false)
        end
      end
    end

    remove_column :users, :project_id
    remove_column :users, :role

  end

  def self.down
    add_column :users, :project_id, :integer
    add_column :users, :role, :string

    User.find_each do |u|
      if u.superadmin
        u.update_attribute(:role, "admin")
      else
        u.project_id = u.projects[0].id
        if u.project_users[0].role == "user"
          u.update_attribute(:role, "project_user")
        else
          u.update_attribute(:role, "project_admin")
        end
      end
    end

    remove_column :users, :superadmin
    drop_table :project_users
  end
end
