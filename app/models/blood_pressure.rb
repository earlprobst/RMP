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
# Filename: blood_pressure.rb
#
#-----------------------------------------------------------------------------

class BloodPressure < Measurement

  validates_presence_of :systolic, :diastolic, :pulse

  def values_string
    "Systolic: " + systolic.to_s + " mmHg Diastolic: " + diastolic.to_s + " mmHg Pulse: " + pulse.to_s + " 1/min"
  end

  def as_json(opts = nil)
    attributes.slice("systolic", "diastolic", "pulse", "measured_at", "user", "registered_at", "uuid")
  end

end
