class DeleteActivities < ActiveRecord::Migration
  def self.up
    drop_table :activities
  end

  def self.down
    create_table :activities do |t|
      t.belongs_to  :gateway,                 :null => false
      t.integer     :activity_message_id,     :null => false
      t.timestamps
    end
  end
end
