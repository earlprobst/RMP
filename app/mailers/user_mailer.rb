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
# Filename: user_mailer.rb
#
#-----------------------------------------------------------------------------

class UserMailer < ActionMailer::Base
  default :from => APP_CONFIG[:admin_email]
  default_url_options[:host] = APP_CONFIG[:site_url]

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @user = user
    @url = login_path

    mail  :to => user.email,
          :subject => "[Biocomfort rmp] Welcome to the site"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_instructions.subject
  #
  def activation_instructions(user)
   @user = user
   @account_activation_url = "#{APP_CONFIG[:site_url]}/activate/#{user.perishable_token}"

    mail  :to => user.email,
          :subject => "[Biocomfort rmp] Activation Instructions"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.forgot_password.subject
  #
  def password_reset_instructions(user)
    @user = user
    @edit_password_reset_url = "#{APP_CONFIG[:site_url]}/password_resets/#{user.perishable_token}/edit"

    mail  :to => user.email,
          :subject => "[Biocomfort rmp] Password Reset Instructions"
  end
end
