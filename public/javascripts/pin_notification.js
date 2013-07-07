/*-----------------------------------------------------------------------------
 *
 * Biocomfort Diagnostics GmbH & Co. KG
 *            Copyright (c) 2008 - 2012. All Rights Reserved.
 * Reproduction or modification is strictly prohibited without express
 * written consent of Biocomfort Diagnostics GmbH & Co. KG.
 *
 *-----------------------------------------------------------------------------
 *
 * Contact: vollmer@biocomfort.de
 * 
 *-----------------------------------------------------------------------------
 * 
 * Filename: pin_notifications.js
 *
 *-----------------------------------------------------------------------------
 */

$(document).ready(function() { 
  $("form.gateway").submit(function(){
    var select1Value = $("#gateway_configuration_attributes_network_1_id").val() == "2"
    var select2Value = $("#gateway_configuration_attributes_network_2_id").val() == "2"
    var select3Value = $("#gateway_configuration_attributes_network_3_id").val() == "2"
    if(select1Value || select2Value || select3Value) {
      var notPinValue = $("#gateway_configuration_attributes_gprs_pin").val() == ""
      if(notPinValue) {
        var response = confirm("You haven't introduced the GPRS pin. This feature is only available from mgw109 package version 0.1.8-3.");
        if(!response) {
          return false;
        }
      }
    }
  });
});
