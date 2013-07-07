class CreateSystemStates < ActiveRecord::Migration
  def self.up
    create_table :system_states do |t|
      t.belongs_to  :gateway,       :null => false
      t.string      :ip

      t.timestamps
    end
  end

  def self.down
    drop_table :system_states
  end
end
