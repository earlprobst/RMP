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
# Filename: system_states_controller.rb
#
#-----------------------------------------------------------------------------

class SystemStatesController < InheritedResources::Base
  belongs_to :gateway
  load_and_authorize_resource :gateway, :find_by => :serial_number

  actions :index
  respond_to :html
  respond_to :xml

  protected

    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 1)
      paginate_options[:order] ||= (params[:oder] || 'created_at DESC')
      @system_states ||= end_of_association_chain.paginate(paginate_options)
    end

    def begin_of_association_chain
      @gateway
    end
end
