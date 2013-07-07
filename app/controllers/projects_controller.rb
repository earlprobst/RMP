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
# Filename: projects_controller.rb
#
#-----------------------------------------------------------------------------

class ProjectsController < InheritedResources::Base

  load_and_authorize_resource

  actions :index, :show, :new, :create, :edit, :update, :destroy
  respond_to :html

  after_filter :modify_configuration_state, :only => [:create, :update]

  def modify_configuration_state
    if @project.errors.empty?
      @project.gateways.each do |gateway|
        gateway.configuration.modify_configuration_state(true)
        gateway.save
      end
    end
  end

  protected
    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 10)
      paginate_options[:order] ||= (params[:oder] || 'name ASC')
      @projects ||= end_of_association_chain.paginate(paginate_options)
    end

    def begin_of_association_chain
      if @current_user.is_superadmin?
        super
      else
        @current_user
      end
    end
end
