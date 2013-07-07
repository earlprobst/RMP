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
# Filename: measurements_helper.rb
#
#-----------------------------------------------------------------------------

module MeasurementsHelper

  def measurement_values(measurement)

    case measurement.class.name
      when "BloodPressure"
        content_tag :ul do
          concat(content_tag :li, "Systolic: #{measurement.systolic.to_s} mmHg")
          concat(content_tag :li, "Diastolic: #{ measurement.diastolic.to_s} mmHg")
          concat(content_tag :li, "Pulse: #{measurement.pulse.to_s} 1/min")
        end

      when "BloodGlucose"
        content_tag :ul do
          content_tag :li, "Glucose: #{measurement.glucose.to_s} mg/dl"
        end
      when "BodyWeight"
        content_tag :ul do
          concat(content_tag :li, "Weight: #{measurement.weight.to_s} Kg")
          concat(content_tag :li, "Impedance #{measurement.impedance.to_s} Ohm")
          concat(content_tag :li, "Body fat #{measurement.body_fat.to_s}%")
          concat(content_tag :li, "Body water: #{measurement.body_water.to_s}%")
          concat(content_tag :li, "Muscle mass: #{measurement.muscle_mass.to_s}%")
        end
    end
  end
end
