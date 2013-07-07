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
 * Filename: gateway_new_form.js
 *
 *-----------------------------------------------------------------------------
 */

$(document).ready(function() {
	var configuration_params = $('.configuration_params');
	var show_configuration_link = $('a.show_configuration_link');
	var reset_configuration_link = $('a.reset_configuration_link');
	var form_button = $('input#gateway_submit');

	configuration_params.hide();
	
	if($('.configuration_params .error').length > 0){
		show_configuration_link.hide();
		reset_configuration_link.show();
		configuration_params.show();
		form_button.val('Add gateway');
	}

	// Show the configuration params
	show_configuration_link.click(function() {
		show_configuration_link.hide();
		reset_configuration_link.show();
		configuration_params.show();
		form_button.val('Add gateway');
		return false;
	});

	// Reset the configuration params to default values
	reset_configuration_link.click(function() {
		show_configuration_link.show();
		reset_configuration_link.hide();
		configuration_params.hide();
		form_button.val('Add gateway with default values');
		resetDefaultValues();
		return false;
	});
});

function resetDefaultValues() {
	// Reset the passwords fields
	$('input:password').val('');
	// Uncheck the connectors fields
	$('#connectors input:checkbox').attr('checked', false);
	// Reset the text inputs, checkboxes and selectboxes
	for(i = 0; i < default_fields.length; i++) {
		field_name = 'gateway_configuration_attributes_' + default_fields[i];
		value = default_values[i];
		// Input fields
		if($('input#' + field_name + ':text').length > 0) {
			if(value == 'nil') {
				$('input#' + field_name).val('');
			} else {
				$('input#' + field_name).val(value);
			}
		}
		// Checkbox fields
		if($('input#' + field_name + ':checkbox').length > 0) {
			if(value == 'true') {
				$('input#' + field_name).attr('checked', true);
			} else {
				$('input#' + field_name).attr('checked', false);
			}
		}
		// Selectbox fields
		if($('select#' + field_name).length > 0) {
			options = $('select#' + field_name + ' option');
			if(value == 'nil') {
				$(options[0]).attr('selected', 'selected');
			} else {
				for(j = 0; j < options.length; j++) {
					if($(options[j]).val() == value) {
						$(options[j]).attr('selected', 'selected');
					}
				}
			}
		}
	};
}
