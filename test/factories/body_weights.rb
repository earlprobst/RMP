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
# Filename: body_weights.rb
#
#-----------------------------------------------------------------------------

Factory.define :body_weight, :class => BodyWeight do |f|
  f.uuid                  { "#{SecureRandom.hex(10)}"}
  f.medical_device        { |medical_device| medical_device.association(:medical_device) }
  f.session_id            { "#{SecureRandom.random_number(10)+1}" }
  f.measured_at           { DateTime.now - 0.05 }
  f.transmitted_data_set  true
  f.user                  { "#{SecureRandom.random_number(7)+1}" }
  f.registered_at         { DateTime.now - 0.048 }
  f.weight                { "#{SecureRandom.random_number(100).to_f}" }
  f.impedance             { "#{SecureRandom.random_number(100).to_f}" }
  f.body_fat              { "#{SecureRandom.random_number(100).to_f}" }
  f.body_water            { "#{SecureRandom.random_number(100).to_f}" }
  f.muscle_mass           { "#{SecureRandom.random_number(100).to_f}" }
end
