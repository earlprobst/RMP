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
# Filename: body_weight.rb
#
#-----------------------------------------------------------------------------

class BodyWeight < Measurement

  validates_presence_of :weight, :impedance, :body_fat, :body_water, :muscle_mass

  def values_string
    "Weight: " + weight.to_s + " Kg Impedance " + impedance.to_s + " Ohm Body fat " + body_fat.to_s + " % Body water: " + body_water.to_s + " % Muscle mass: " + muscle_mass.to_s + " %"
  end

  def as_json(opts = nil)
    attributes.slice("weight", "impedance", "body_fat", "body_water", "muscle_mass", "measured_at", "user", "registered_at", "uuid")
  end


end
