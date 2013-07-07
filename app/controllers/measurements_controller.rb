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

class MeasurementsController < InheritedResources::Base
  belongs_to :medical_device, :optional => true
  load_and_authorize_resource :medical_device, :find_by => :serial_number
  load_and_authorize_resource :measurement, :through => :medical_device, :find_by => :uuid

  actions :index, :show
  respond_to :html
  respond_to :xml

  protected

    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 10)
      paginate_options[:order] ||= (params[:oder] || 'measured_at DESC')
      @measurements ||= end_of_association_chain.paginate(paginate_options)
    end
    
    def resource
      if params[:last]
        md = MedicalDevice.find_by_serial_number(params[:medical_device_id])
        @measurement = Measurement.where(:medical_device_id => md).limit(1).first || []
      end
    end

    def begin_of_association_chain
       if @current_user.is_superadmin?
        super
      else
        @current_user
      end
    end

end
