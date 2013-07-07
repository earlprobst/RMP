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
# Filename: measurements_controller.rb
#
#-----------------------------------------------------------------------------

class Api::MeasurementsController < Api::ApiController

  skip_before_filter :require_user
  before_filter :authenticate

  actions :create, :show, :index
  respond_to :xml

  def create
    xml = Hash.from_xml(request.body.read)
    key = xml.keys.first
    type = key.camelize.constantize
    serial_number = xml[key]["medical_device_serial_number"]
    xml[key].delete("medical_device_serial_number")
    medical_device = MedicalDevice.find_by_serial_number(serial_number)

    if medical_device.present? and medical_device.gateway == @gateway
      @measurement = Measurement.new(xml[key])
      @measurement.type = type.name
      @measurement.medical_device = medical_device

      @gateway.activities_date.measurement_upload = Time.now
      @gateway.activities_date.save

      only_params = [:type, :measured_at, :registered_at, :session_id, :transmitted_data_set, :user, :uuid]
      only_params = only_params + [:systolic, :diastolic, :pulse] if @measurement.type == 'BloodPressure'
      only_params = only_params + [:glucose] if @measurement.type == 'BloodGlucose'
      only_params = only_params + [:weight, :impedance, :body_fat, :body_water, :muscle_mass] if @measurement.type == 'BodyWeight'
     
      create!(:skip_types => true, :only => only_params, :methods => [:medical_device_serial_number])
    else
      render :xml => '', :status => :forbidden
    end
  end

  protected
    def begin_of_association_chain
      @gateway
    end

    def resource
      begin_of_association_chain.measurements.find_by_uuid!(params[:id])
    end

end
