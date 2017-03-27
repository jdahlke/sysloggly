require 'multi_json'
require 'socket'
require 'uri'

module Sysloggly
  module Client

    # Creates a new client that conforms to the Logger::LogDevice specification.
    #
    # @return [Sysloggly::Client::Syslog, Sysloggly::Client::FileLog] returns an instance of an Sysloggly client class
    # @api public
    def self.new(url, opts = {})
      unless url
        raise InputURLRequired.new
      end

      begin
        input_uri = URI.parse(url)
      rescue URI::InvalidURIError => e
        raise InputURLRequired.new("Invalid Input URL: #{url}")
      end

      case input_uri.scheme
      when 'file'
        Sysloggly::Client::Filelog.new(input_uri, opts)
      when 'udp', 'tcp'
        Sysloggly::Client::Syslog.new(input_uri, opts)
      else
        raise Sysloggly::UnsupportedScheme.new("#{input_uri.scheme} is unsupported")
      end
    end


    module InstanceMethods

      # Specifies the date/time format for this client
      def datetime_format
        "%b %e %H:%M:%S"
      end

      def setup_options
        @hostname = opts[:hostname] || Socket.gethostname.split('.').first
        @progname = opts[:progname]
        @custom_options = opts.except(:hostname, :progname)

        if ['udp', 'tcp'].include?(@input_uri.scheme) && !@input_uri.path.empty?
          if @facility = @input_uri.path.split('/')[1]
            @facility = @facility.to_i
            unless @facility <= 23 && @facility >= 0
              raise Sysloggly::UnknownFacility.new(@facility.to_s)
            end
          end
        else
          @facility = 23
        end
      end

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
      def formatter
        proc do |severity, datetime, progname, msg|
          processid = Process.pid
          message = "<#{pri(severity)}>#{datetime.strftime(datetime_format)} #{@hostname} "

          # Include process ID in progname/log tag - RFC3164 § 5.3
          message << "#{@progname || progname || $0}[#{processid}]: "

          # Only log JSON to Syslog
          message << MultiJson.dump(hashify_message(msg).merge(@custom_options))

          if ['file', 'tcp'].include?(@input_uri.scheme )
            message << "\r\n"
          end
          message
        end
      end

      def hashify_message(msg)
        if msg.is_a?(Hash)
          msg
        elsif msg.is_a?(Exception)
          { exception_class: msg.class.name, message: msg.message }
        elsif msg.is_a?(String)
          begin
            JSON.parse(msg)
          rescue
            { message: msg }
          end
        else
          { message: msg.inspect }
        end
      end
    end
  end
end
