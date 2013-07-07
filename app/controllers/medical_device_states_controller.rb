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
# Filename: medical_device_states_controller.rb
#
#-----------------------------------------------------------------------------

class MedicalDeviceStatesController < InheritedResources::Base
  belongs_to :gateway
  load_and_authorize_resource :gateway, :find_by => :serial_number

  actions :show
  respond_to :xml

  protected

  def resource
    if params[:current]
      medical_device = MedicalDevice.find_by_serial_number(params[:medical_device_id])
      @medical_device_state = medical_device.current_medical_device_state || []
    end
  end

  def begin_of_association_chain
    @gateway
  end
end
