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
# Filename: medical_devices_controller.rb
#
#-----------------------------------------------------------------------------

class MedicalDevicesController < InheritedResources::Base
  belongs_to :gateway
  load_and_authorize_resource :gateway, :find_by => :serial_number
  load_and_authorize_resource :medical_device, :through => :gateway, :find_by => :serial_number
  

  after_filter :modify_configuration_state, :only => [:create, :update, :destroy]

  actions :new, :create, :destroy, :edit, :update, :show, :index
  respond_to :html
  respond_to :xml, :only => [:index]

  def modify_configuration_state
    if @medical_device.errors.empty?
      @medical_device.gateway.configuration.modify_configuration_state(true)
      @medical_device.gateway.save
    end
  end

  def new
    @gateway = Gateway.find_by_serial_number(params[:gateway_id])
    @medical_device = @gateway.medical_devices.build
    user = @medical_device.users.build
    user.default = true
    new!
  end

  def create
    create!{ gateway_path(@medical_device.gateway) }
  end

  def update
    if params[:medical_device][:serial_number] == ""
      params[:medical_device].delete(:serial_number)
    end
    update!{ gateway_path(@medical_device.gateway) }
  end

  def destroy
    destroy!{ gateway_path(@medical_device.gateway) }
  end
  
end
