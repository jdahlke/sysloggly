module Sysloggly
  if Object.const_defined?(:Rails) and Rails.const_defined?(:Railtie)
    # @private
    class Railtie < Rails::Railtie
      initializer 'sysloggly.initialize' do |app|
        config = app.config

        # find app name and app environment
        app_name = Rails.application.class.parent_name
        environment = Rails.env
        begin
          # try to find a honeybadger configuration
          honeybadger = YAML.load_file(Rails.root.join('config', 'honeybadger.yml'))
          environment = honeybadger['env'].to_s
        rescue
        end

        # add https://github.com/crohr/syslogger
        syslogger = Syslogger.new(app_name, Syslog::LOG_PID, Syslog::LOG_LOCAL7)
        config.syslogger = syslogger

        # add https://github.com/roidrage/lograge
        config.lograge.enabled = true
        config.lograge.formatter = Lograge::Formatters::Json.new
        config.lograge.keep_original_rails_log = true
        config.lograge.logger = config.syslogger
        config.lograge.custom_options = lambda do |event|
          { env: environment }
        end
      end
    end
  end
end
