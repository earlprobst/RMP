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
# Filename: connector.rb
#
#-----------------------------------------------------------------------------

class Connector < ActiveHash::Base
  include ActiveHash::Enum

  self.data = [
    { :id => 1, :name => 'MyVitali', :send_method => :myvitali_send_measurement },
  ]

  enum_accessor :name

  def self.myvitali_send_measurement(measurement_id)
    params = { :apiToken => MyVitali.token }
    begin
      measurement = Measurement.find(measurement_id)
      serial_number = measurement.medical_device.serial_number
      params['serial'] = serial_number[0..5] + " " + serial_number[6..7] + " " + serial_number[8..11] + " " + serial_number[12..15]
      params['userNr'] = measurement.user
      params['date'] = measurement.measured_at.strftime('%Y-%m-%d %H:%M:%S')
      case measurement.type
      when "BloodGlucose"
        uri_str = MyVitali.url + '/glucose'
        params['glucose'] = measurement.glucose
      when "BloodPressure"
        uri_str = MyVitali.url + '/bloodpressure'
        params['systolic'] = measurement.systolic
        params['diastolic'] = measurement.diastolic
        params['pulse'] = measurement.pulse
      when "BodyWeight"
        uri_str = MyVitali.url + '/scale'
        params['bodyWeight'] = measurement.weight
        params['bodyFat'] = measurement.weight
        params['bodyWater'] = measurement.body_water
        params['muscleMass'] = measurement.muscle_mass
        params['impedance'] = measurement.impedance
      else
        false
      end
      uri = URI(uri_str)
      uri.query = params.to_query
      res = Net::HTTP.get_response(uri)
      raise if not res.is_a?(Net::HTTPSuccess)
      true
    rescue Exception => error
      ::Rails.logger.error "Error in MyVitali response: #{error.message}"
      false
    end
  end

end
