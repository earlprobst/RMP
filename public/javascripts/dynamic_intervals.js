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
 * Filename: dynamic_intervals.js
 *
 *-----------------------------------------------------------------------------
 */

function debugModeSelected(){
  for(var i = 0; i < selectboxes.length; i++) {
    var options = ['<option value=""></option>'];
    if($("#gateway_debug_mode:checked").val() == 1) {
      for(var j = 0; j < debug_options.length; j++) {
        if($(selectboxes[i]+" option:selected").val() == debug_options[j][0])
          options += '<option selected="selected" value="' + debug_options[j][0] + '">' + debug_options[j][1] + '</option>';
        else
          options += '<option value="' + debug_options[j][0] + '">' + debug_options[j][1] + '</option>';
      }
    }
    for(var j = 0; j < normal_options.length; j++) {
      if($(selectboxes[i]+" option:selected").val() == normal_options[j][0]) {
        options += '<option selected="selected" value="' + normal_options[j][0] + '">' + normal_options[j][1] + '</option>';
      } else {
        options += '<option value="' + normal_options[j][0] + '">' + normal_options[j][1] + '</option>';
      }
    }
    $("select"+selectboxes[i]).html(options);
  }
  
  // Show the log configuration params in debug mode
  if($("#gateway_debug_mode:checked").val() == 1) {
    $("#log_configurations").show();
    /*
    if($("#gateway_configuration_attributes_send_log_files:checked").val() == 1) {
      
    } else {
      
    }
    */
  } else {
    $("#log_configurations").hide();
  }
}

$(document).ready(function() { 
  debugModeSelected();
  
  $("#gateway_debug_mode").change(function() {
    debugModeSelected();
  });  
});
