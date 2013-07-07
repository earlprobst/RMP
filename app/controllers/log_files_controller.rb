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
# Filename: log_files_controller.rb
#
#-----------------------------------------------------------------------------

class LogFilesController < InheritedResources::Base
  belongs_to :gateway
  load_and_authorize_resource :gateway, :find_by => :serial_number
  load_and_authorize_resource :log_file, :through => :gateway

  actions :destroy
  respond_to :html

  def destroy
    destroy!{gateway_path(@log_file.gateway)}
  end
end
