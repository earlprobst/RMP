class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.belongs_to  :gateway,                 :null => false
      t.integer     :activity_message_id,     :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
