module Sysloggly
  module Formatters
    class SyslogFormatter < SimpleFormatter
      # Syslog specific PRI calculation.
      # See RFC3164 4.1.1
      def pri(severity)
        severity_value = case severity
                         when "FATAL"
                           0
                         when "ERROR"
                           3
                         when "WARN"
                           4
                         when "INFO"
                           6
                         when "DEBUG"
                           7
                         end
        (@facility << 3) + severity_value
      end

      # Generate a syslog compat message
      # See RFC3164 4.1.1 - 4.1.3
      #
      # @api public
      def call(severity, datetime, progname, payload)
        message = "<#{pri(severity)}>#{datetime.strftime(datetime_format)} #{@hostname} "

        # Include process ID in progname/log tag - RFC3164 § 5.3
        message << "#{@progname || progname || $0}[#{Process.pid}]: "

        message << MultiJson.dump(hashify_message(payload).merge(@custom_options))
        message << "\r\n"  if ["file", "tcp"].include?(@input_uri.scheme)

        message
      end
    end
  end
end
