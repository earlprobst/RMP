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
 * Filename: gateway_vpn_actions.js
 *
 *-----------------------------------------------------------------------------
 */

$(document).ready(function() {
	$('a.gateway_vpn_link').click(function() {
		$('form.gateway_vpn_form').submit();
		return false;
	});
	
	$('form.gateway_vpn_form').submit(function() {
		if(confirm("You are going to open VPN. Are you sure?")){
			$.ajax({
			  type: "PUT",
			  url: this.action,
			  data: $(this).serialize(),
			  beforeSend : function(xhr) {
				xhr.setRequestHeader("Accept", "text/javascript");
			  },
			  success : function(data) {
			  	$('a.gateway_shutdown_link').hide();
			  	$('a.gateway_reboot_link').hide();
				$('a.gateway_vpn_link').hide();
				$('a.gateway_removemeasurements_link').hide();
			  	$('.open_vpn_msg').show();
			  	return false;
			  }
			});
		}
		return false;
	});
});
