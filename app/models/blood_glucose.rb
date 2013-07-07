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
# Filename: blood_glucose.rb
#
#-----------------------------------------------------------------------------

class BloodGlucose < Measurement

  validates_presence_of :glucose

  def values_string
    "Glucose: " + glucose.to_s + " mg/dl"
  end

  def as_json(opts = nil)
    attributes.slice("glucose", "measured_at", "user", "registered_at", "uuid")
  end

end
