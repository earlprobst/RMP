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
# Filename: blood_pressures.rb
#
#-----------------------------------------------------------------------------

Factory.define :blood_pressure, :class => BloodPressure do |f|
  f.uuid                  { "#{SecureRandom.hex(10)}"}
  f.medical_device        { |medical_device| medical_device.association(:medical_device) }
  f.session_id            { "#{SecureRandom.random_number(10)+1}" }
  f.measured_at           { Time.now - 0.05 }
  f.transmitted_data_set  true
  f.user                  { "#{SecureRandom.random_number(7)+1}" }
  f.registered_at         { Time.now - 0.048 }
  f.systolic              { "#{SecureRandom.random_number(100)}" }
  f.diastolic             { "#{SecureRandom.random_number(100)}" }
  f.pulse                 { "#{SecureRandom.random_number(100)}" }
end
