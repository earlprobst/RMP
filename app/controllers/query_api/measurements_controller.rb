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

class QueryApi::MeasurementsController < ApplicationController

  def index
    @measurements = Measurement.
      where("gateways.serial_number = ?", params[:gw_serial]).
      where("medical_devices.serial_number = ?", params[:md_serial]).
      where("measurements.user = ?", params[:md_user]).
      where("measured_at >= ?", params[:measured_from]).
      where("measured_at <= ?", params[:measured_to]).
      user_is(current_user)

    respond_to do |format|
      format.json { render :json => @measurements }
    end
  end

end
