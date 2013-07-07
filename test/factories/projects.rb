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
# Filename: projects.rb
#
#-----------------------------------------------------------------------------

Factory.define :project, :class => Project do |f|
  f.name                  { Faker::Name.name }
  f.contact_person        { Faker::Name.name }
  f.email                 { Faker::Internet.email }
  f.address               { Faker::Address }
  f.rmp_url               "http://remote.manage.me:8000/remote/"
  f.medical_data_url      "http://medical.data.me:9000/data/"
end
