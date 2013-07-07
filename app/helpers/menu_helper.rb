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
# Filename: menu_helper.rb
#
#-----------------------------------------------------------------------------

# Methods added to this helper will be available to all templates in the application.
module MenuHelper
  def menu_tab(name, current)
    if(name == current)
      {:id => "navigation_menu_#{name}", :class => "tab navigation_menu_#{name} active"}
    else
      {:id => "navigation_menu_#{name}", :class => "tab navigation_menu_#{name}"}
    end
  end
end
