class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|

      t.string    :login,               :null => false                # optional
      t.string    :email,               :null => false                # optional
      t.string    :crypted_password,    :null => false                # optional
      t.string    :password_salt,       :null => false                # optional
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional
      t.string    :perishable_token,    :null => false                # optional

      # Magic columns, just like ActiveRecord's created_at and updated_at.
      #  These are automatically maintained by Authlogic if they are present.

      t.integer   :login_count,         :null => false, :default => 0 # optional
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional
      t.datetime  :last_request_at                                    # optional
      t.datetime  :current_login_at                                   # optional
      t.datetime  :last_login_at                                      # optional
      t.string    :current_login_ip                                   # optional
      t.string    :last_login_ip                                      # optional

      t.timestamps
      
    end
  end

  def self.down
    drop_table :users
  end
end
