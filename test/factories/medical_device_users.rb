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
# Filename: medical_device_users.rb
#
#-----------------------------------------------------------------------------

Factory.define :medical_device_user, :class => MedicalDeviceUser do |f|
  f.medical_device              { |md| md.association(:medical_device) }
  f.md_user                     { rand 9 }
  f.gender                      'female'
  f.physical_activity           { rand 3 }
  f.age                         { rand 50 }
  f.height                      { SecureRandom.random_number(200) }
  f.units                       { 1 }
  f.display_body_fat            { true }
  f.display_body_water          { true }
  f.display_muscle_mass         { true }
  f.default                     { false }
end
