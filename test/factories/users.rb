#-----------------------------------------------------------------------------
#
# Biocomfort Diagnostics GmbH & Co. KG
#            Copyright (c) 2008 - 2012. All Rights Reserved.
# Reproduction or modification is strictly prohibited without express
# written consent of Biocomfort Diagnostics GmbH & Co. KG.
#
#-----------------------------------------------------------------------------
#
# Contact: vollmer@biocomfort.de
#
#-----------------------------------------------------------------------------
#
# Filename: users.rb
#
#-----------------------------------------------------------------------------

Factory.define :user, :class => User do |f|
  f.email                       { Faker::Internet.email }
  f.name                        { Faker::Name.name }
  f.password                    'password'
  f.password_confirmation       'password'
  f.superadmin                  false
  f.project_users_attributes    { [{:project_id => Factory(:project).id, :role => "user"}]}
end
