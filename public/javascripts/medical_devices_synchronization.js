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
 * Filename: medical_devices_synchronization.js
 *
 *-----------------------------------------------------------------------------
 */

$(document).ready(function() {
	$('a.gateway_synchronize_link').click(function() {
		$('form.gateway_synchronize_form').submit();
		return false;
	});
	$('form.gateway_synchronize_form').submit(function() {
		var form = $(this);
		$.ajax({
		  type: "PUT",
		  url: this.action,
		  data: $(this).serialize(),
		  beforeSend : function(xhr) {
			xhr.setRequestHeader("Accept", "text/javascript");
		  },
		  success : function(data) {
		    $('a.gateway_synchronize_link').hide();
			$('.synchronize_msg').show();
			return false;
		  }
		});
		return false;
	});
});
