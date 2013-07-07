# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

if defined?(User)
  Object.send :remove_const, "User"
  load "#{Rails.root}/app/models/user.rb"
end

User.create(:name => "aentos@aentos.es", :email => "aentos@aentos.es", :password => "aentos", :password_confirmation => "aentos", :superadmin => true, :active => true)
