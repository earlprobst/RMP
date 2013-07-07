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
# Filename: activations_controller.rb
#
#-----------------------------------------------------------------------------

class ActivationsController < ApplicationController

  skip_before_filter :require_user
  before_filter :require_no_user

  def create
    @user = User.find_using_perishable_token(params[:activation_code], 1.week)
    if @user.present? and @user.activate!
        flash[:notice] = "Your account has been activated! Please, set your password."
        UserSession.create(@user, false) # Log user in manually
        @user.deliver_welcome!
        @user.reset_perishable_token!
        redirect_to edit_user_url(@user)
    else
      flash[:error] = "Wrong activation code"
      redirect_to login_url
    end
  end
end
