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
# Filename: medical_devices_helper.rb
#
#-----------------------------------------------------------------------------

module MedicalDevicesHelper

  def link_to_add_fields(name, f, association)  
    new_object = f.object.class.reflect_on_association(association).klass.new  
    fields = f.semantic_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render(new_object.class.to_s.tableize + "/form", :f => builder)  
    end
    link_to_function(name, raw("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"), :id => 'add_field')  
  end

end
