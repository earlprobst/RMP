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
 * Filename: configuration_form.js
 *
 *-----------------------------------------------------------------------------
 */

$(document).ready(function() {
  
  // Show the params of the networks selected
  show_networks();
  $('#gateway_configuration_attributes_network_1_id').change(function(){ show_networks() });
  $('#gateway_configuration_attributes_network_2_id').change(function(){ show_networks() });
  $('#gateway_configuration_attributes_network_3_id').change(function(){ show_networks() });
  
  // Show the gprs authentification if is checked
  if($('#gateway_configuration_attributes_gprs_username').val() != '' || $('#gateway_configuration_attributes_gprs_password').val() != ''){
    $('#gateway_configuration_attributes_gprs_authentication').attr('checked', true);
  }
  gprs_authentication();
  $('#gateway_configuration_attributes_gprs_authentication').change(function(){
    gprs_authentication();
  });
  
  // Check if there are proxy fields completed
  networks = ["ethernet", "gprs", "pstn"];
  for(i in networks){
    var network = networks[i];
    if(network_has_proxy(network)) {
      $('a.show-'+network+'-proxy').hide();
      $('a.hide-'+network+'-proxy').show();
      $('#'+network+'-proxy-configuration').show();
    } else {
      $('a.hide-'+network+'-proxy').hide();
      $('a.show-'+network+'-proxy').show();
      $('#'+network+'-proxy-configuration').hide();
    }
  }
  
  // Behaviour 'Use proxy' link
  $('a.show-ethernet-proxy').click(function() {
    use_proxy('ethernet');
    return false;
  });
  $('a.show-gprs-proxy').click(function() {
    use_proxy('gprs');
    return false;
  });
  $('a.show-pstn-proxy').click(function() {
    use_proxy('pstn');
    return false;
  });
  
  // Behaviour 'Don't use proxy' link
  $('a.hide-ethernet-proxy').click(function() {
    dont_use_proxy('ethernet');
    return false;
  });
  $('a.hide-gprs-proxy').click(function() {
    dont_use_proxy('gprs');
    return false;
  });
  $('a.hide-pstn-proxy').click(function() {
    dont_use_proxy('pstn');
    return false;
  });
});

function gprs_authentication(){
  if($('#gateway_configuration_attributes_gprs_authentication').attr('checked')) {
    $('#gateway_configuration_attributes_gprs_username_input').show();
    $('#gateway_configuration_attributes_gprs_password_input').show();
  } else {
    $('#gateway_configuration_attributes_gprs_username_input').hide();
    $('#gateway_configuration_attributes_gprs_password_input').hide();
    $('#gateway_configuration_attributes_gprs_username').val('');
    $('#gateway_configuration_attributes_gprs_password').val('');
  }
}

function show_networks(){
  hide_networks();
  show_network($('#gateway_configuration_attributes_network_1_id option:selected').val());
  show_network($('#gateway_configuration_attributes_network_2_id option:selected').val());
  show_network($('#gateway_configuration_attributes_network_3_id option:selected').val());
}

function hide_networks(){
  $('#ethernet-configuration').hide();
  $('#gprs-configuration').hide();
  $('#pstn-configuration').hide();
}

function show_network(network_id){
  switch(network_id){
    case '1':
      network = 'ethernet';
      break;
    case '2':
      network = 'gprs';
      break;
    case '3':
      network = 'pstn';
      break;
    default:
      return;
  }
  $('#' + network + '-configuration').show();
}

function use_proxy(network){
  $('a.show-'+network+'-proxy').hide();
  $('a.hide-'+network+'-proxy').show();
  $('#'+network+'-proxy-configuration').show();
}

function dont_use_proxy(network){
  $('a.show-'+network+'-proxy').show();
  $('a.hide-'+network+'-proxy').hide();
  $('#'+network+'-proxy-configuration').hide();
  reset_proxy_configuration(network);
}

function reset_proxy_configuration(network){
  n = $('#'+network+'-proxy-configuration input').length;
  for(i = 0; i < n; i++){
    field = $($('#'+network+'-proxy-configuration input')[i]);
    if(field.attr('type') == 'text' || field.attr('type') == 'password') {
      field.val('');
    }
    if(field.attr('type') == 'checkbox') {
      field.attr('checked', false);
    }
  }
  return false;
}

function network_has_proxy(network){
  n = $('#'+network+'-proxy-configuration input').length;
  for(i = 0; i < n; i++){
    field = $($('#'+network+'-proxy-configuration input')[i]);
    if(field.attr('type') == 'text' && field.val() != '') {
      return true;
    }
    if(field.attr('type') == 'checkbox' && field.attr('checked') == true) {
      return true;
    }
  }
  return false;
}
