class ModifyRepeatedProjectNames < ActiveRecord::Migration
  def self.up
    Project.all.each do |project|
      if Project.where(:name => project.name).count > 1
        Project.where(:name => project.name).each {|p| p.update_attributes({:name => (project.name + rand(100).to_s)})}
      end
    end
  end

  def self.down
  end
end
