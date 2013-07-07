class DestroyUsersWithoutProject < ActiveRecord::Migration
  def self.up
    User.all.each {|user| user.destroy if (user.projects.count == 0 && !user.superadmin)}
  end

  def self.down
  end
end
