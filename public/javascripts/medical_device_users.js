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
 * Filename: medical_device_users.js
 *
 *-----------------------------------------------------------------------------
 */

$(document).ready(function() {
  $('.user_destroy_field').each(function(index){
    if($(this).val() == '1' || $(this).val() == 'true'){
      $(this).parent().hide();
    }
  });

  $('input.default_field:checked').addClass('checked');
  update_md_user();
  update_scale_links();
  $('select#medical_device_type_id').change(function() {
    update_scale_links();
  });
  $('input.default_field').live('click', function() {
    if($(this).attr('checked')){
      // Check default
      if($('input.checked').length > 0){
        $('input.checked').attr('checked', false);
        $('input.checked').removeClass('checked');
      }
      $(this).addClass('checked');
    } else {
      // Uncheck default
      $(this).removeClass('checked');
    }
  });
});

function update_scale_links(){
  if($('select#medical_device_type_id').length > 0){
    if($('select#medical_device_type_id option:selected').val() == 3){
      $(".optional_fields").show();
    } else {
      $(".optional_fields").hide();
	  $(".optional_fields input").each(function(index){
	    if($(this).attr('type') == 'checkbox'){
	      $(this).attr('checked', false);
	    } else {
	      $(this).val('');
	    }
	  });
    }
  }
}

function update_md_user() {
  $('div.fields:visible div.user h3').each(function(index){
    $(this).text("User "+(index+1));
    $(this).parent().find('input:hidden').val((index+1));
  });
}

function remove_fields (link) {
  $(link).prev('input[type=hidden]').val('1');
  $(link).parent().hide();
  if($(link).parent().find('input.checked').length > 0){
    $('input.checked').attr('checked', false);
    $('input.checked').removeClass('checked');
  }
  update_md_user();
  var num_fields = ($('div.fields').length) - ($('div.fields:hidden').length);
  if(num_fields == 8){
    $('#add_field').show();
  }
  if(num_fields == 1){
    $('div.fields:visible a').last().hide();
  }
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    var num_fields = ($('div.fields').length) - ($('div.fields:hidden').length);
    if(num_fields < 8){
      $(link).before(content.replace(regexp, new_id));
      update_md_user();
      if(num_fields == 7) {
        $(link).hide();
      }
      if(num_fields == 1){
        $('div.fields:visible').first().find('a').last().show();
      }
    }
    update_scale_links();
}

