#
# Sysloggly default configuration:
#   @config progname: Rails app name
#   @config env:      Rails env
#   @config logger:   file log to sysloggly.log in the rails log directory
#
module Sysloggly
  # @private
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      Sysloggly.configure do |config|
        config.progname ||= app.class.parent_name
        config.env ||= Rails.env
        config.uri ||= "file://#{Rails.root.join('log','sysloggly.log')}"

        config.logger = Sysloggly.new(config.uri, {
          env: config.env,
          progname: config.progname
        })
      end

      app.configure do
        # @see https://github.com/roidrage/lograge
        config.lograge.enabled = true
        config.lograge.formatter = Lograge::Formatters::Json.new
        config.lograge.keep_original_rails_log = true
        config.lograge.logger = Sysloggly.logger
      end
      Lograge.setup(app)

      # load extensions
      require 'sysloggly/extensions/honeybadger'  if defined?(Honeybadger)
    end
  end
end
