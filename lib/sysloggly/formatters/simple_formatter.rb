require "multi_json"
require "socket"

module Sysloggly
  module Formatters
    class SimpleFormatter
      attr_reader :input_uri, :opts

      def initialize(input_uri, opts)
        @input_uri = input_uri
        @opts = opts

        @hostname = opts[:hostname] || Socket.gethostname.split(".").first
        @progname = opts[:progname]
        @custom_options = opts.except(:hostname, :progname)

        if ["udp", "tcp"].include?(@input_uri.scheme) && !@input_uri.path.empty?
          if @facility = @input_uri.path.split("/")[1]
            @facility = @facility.to_i
            unless @facility <= 23 && @facility >= 0
              raise Sysloggly::UnknownFacility.new(@facility.to_s)
            end
          end
        else
          @facility = 23
        end
      end

      # Specifies the date/time format for this client
      #
      # @api public
      def datetime_format
        "%b %e %H:%M:%S"
      end

      # @api public
      def call(severity, datetime, progname, payload)
        message = "#{severity} [#{datetime.strftime(datetime_format)}] #{@hostname} "

        message << MultiJson.dump(hashify_message(payload).merge(@custom_options))
        message << "\r\n"  if ["file", "tcp"].include?(@input_uri.scheme)

        message
      end

      # @api private
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

