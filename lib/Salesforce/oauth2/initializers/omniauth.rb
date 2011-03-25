# Initializer template
require 'forcedotcom'

# Set the default hostname for omniauth to send callbacks to.
# seems to be a bug in omniauth that it drops the httpS
# this still exists in 0.2.0
OmniAuth.config.full_host = 'https://localhost:3000'

module OmniAuth
  module Strategies
    #tell omniauth to load our strategy
    autoload :Forcedotcom, 'lib/forcedotcom'
  end
end


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :forcedotcom, '3MVG9yZ.WNe6byQDkN5SfIbP0HhAvCqdjOcGL9cXboLq5TeFN9eHOdTuEn443ELqv4ka8ZmzXSbY_kUeg7zMn', '953858431687220560'
end
