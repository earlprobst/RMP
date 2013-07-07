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
# Filename: patients_controller.rb
#
#-----------------------------------------------------------------------------

class QueryApi::PatientsController < ApplicationController

  def index
    @patients = MedicalDeviceUser.connection.select_all(
      MedicalDeviceUser.
        select("gateways.serial_number AS gw_serial, medical_device_users.md_user, medical_devices.type_id AS md_type_id, medical_devices.serial_number AS md_serial").
        joins("INNER JOIN medical_devices ON medical_devices.id = medical_device_users.medical_device_id").
                      joins("INNER JOIN gateways ON gateways.id = medical_devices.gateway_id").
                      joins("INNER JOIN projects ON projects.id = gateways.project_id").
                      joins("INNER JOIN project_users ON project_users.project_id = projects.id").
                      where("project_users.user_id = ?", current_user.id).to_sql
    
    ).each { |p| p["md_type"] = MedicalDeviceType.types[p.delete("md_type_id").to_i] }

    respond_to do |format|
      format.json { render :json => @patients }
    end
  end

end
