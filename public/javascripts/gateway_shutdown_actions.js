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
 * Filename: gateway_shutdown_actions.js
 *
 *-----------------------------------------------------------------------------
 */

$(document).ready(function() {
	$('a.gateway_shutdown_link').click(function() {
		$('form.gateway_shutdown_form').submit();
		return false;
	});
	
	$('a.gateway_reboot_link').click(function() {
		$('form.gateway_reboot_form').submit();
		return false;
	});
	
	$('form.gateway_shutdown_form').submit(function() {
		if(confirm("You are going to shutdown the gateway. Are you sure?")){
			var form = $(this);
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
				$('.shutdown_msg').show();
				return false;
			  }
			});
		}
		return false;
	});
	
	$('form.gateway_reboot_form').submit(function() {
		if(confirm("You are going to reboot the gateway. Are you sure?")){
			var form = $(this);
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
				$('.reboot_msg').show();
				return false;
			  }
			});
		}
		return false;
	});
});
