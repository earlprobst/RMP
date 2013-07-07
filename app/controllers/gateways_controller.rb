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
# Filename: gateways_controller.rb
#
#-----------------------------------------------------------------------------

class GatewaysController < InheritedResources::Base
  before_filter :find_gateway, :only => [:clear_log_files]
  after_filter :update_configuration_state, :only => [:update]
  load_and_authorize_resource :gateway, :find_by => :serial_number  

  actions :index, :new, :create, :show, :edit, :update, :destroy
  respond_to :html
  respond_to :js, :only => [:update]
  respond_to :xml, :only => [:show]
  
  def update_configuration_state
    if @gateway.errors.empty?
      @gateway.configuration.modify_configuration_state(true)
    end
  end

  def find_gateway
    @gateway = Gateway.find_by_serial_number(params[:gateway_id])
  end

  def show
    log_files_paginate_options ||= {}
    log_files_paginate_options[:page] ||= (params[:log_files_page] || 1)
    log_files_paginate_options[:per_page] ||= (params[:log_files_per_page] || 5)
    log_files_paginate_options[:order] ||= (params[:oder] || 'created_at DESC')
    @log_files ||= @gateway.log_files.paginate(log_files_paginate_options)
    show!
  end

  def new
    @gateway = Gateway.new
    @configuration = @gateway.build_configuration
    new!
  end

  def create
    @gateway = Gateway.new(params[:gateway])
    create!
  end

  def update
    if params[:gateway][:serial_number] == ""
      params[:gateway].delete(:serial_number)
    end
    temporal_interval = resource.configuration.configuration_update_interval
    update! do |format|
      if @gateway.errors.empty? # success
        if @gateway.configuration.configuration_update_interval != temporal_interval
          @gateway.configuration.update_attribute(:temporal_configuration_update_interval, temporal_interval)
        end
        if params[:gateway][:removemeasurements_action] == "true"
          @gateway.remove_measurements
        end
        format.html { redirect_to gateway_path(@gateway) }
        format.js { render :text => '"OK"' }
      end
    end
  end

  def clear_log_files
    @gateway.log_files.order("created_at DESC").limit(LogFile::LOG_DELETE_LIMIT).destroy_all
    flash[:notice] = "Log files were successfully destroyed."
    redirect_to gateway_path(@gateway)
  end

  protected
    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 10)
      paginate_options[:order] ||= (params[:oder] || 'serial_number ASC')
      @gateways ||= end_of_association_chain.paginate(paginate_options)
    end

    def begin_of_association_chain
      if @current_user.is_superadmin?
        super
      else
        @current_user
      end
    end

end
