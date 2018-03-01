#
# Sysloggly default configuration for Rails
#
# @config [progname] Rails app name
# @config [env] Rails env
# @config [logger] file log to log/sysloggly.log
# @config [ignore_user_agents] ignores Pingdom bot
#
module Sysloggly
  # @private
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      Sysloggly.configure do |config|
        config.progname ||= app.class.parent_name
        config.env ||= Rails.env
        config.uri ||= "file://#{Rails.root.join("log","sysloggly.log")}"
        config.ignore_user_agents ||= ["Pingdom.com_bot"]

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
        config.lograge.custom_payload do |controller|
          {
            user_agent: controller.request.user_agent
          }
        end
        config.lograge.ignore_custom = lambda do |event|
          custom_payload = event.payload[:custom_payload] || {}
          user_agent = custom_payload[:user_agent] || ""
          Sysloggly.ignore_user_agents.any? { |pattern| user_agent.include?(pattern) }
        end
      end

      Lograge.setup(app)

      require 'sysloggly/extensions/honeybadger'  if defined?(Honeybadger)
    end
  end
end
