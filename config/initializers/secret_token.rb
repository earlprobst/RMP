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
# Filename: secret_token.rb
#
#-----------------------------------------------------------------------------

# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
RemoteManagementPlatform::Application.config.secret_token = '3e260b07c9d739a14d41e473ad6253a21e9b4d4d61236de23f8fc735fb27f2f27792df37c583a04c5bc0c0b3367ced957d75fcd94c81d31df11b1a7b44385030'
