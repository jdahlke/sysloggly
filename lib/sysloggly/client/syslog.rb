module Sysloggly
  module Client
    class Syslog
      include Sysloggly::Client::InstanceMethods

      attr_reader :input_uri, :opts
      attr_reader :syslog

      def initialize(input_uri, opts)
        @input_uri = input_uri
        @opts = opts

        case @input_uri.scheme
        when 'udp'
          @syslog = UDPSocket.new
          @syslog.connect(@input_uri.host, @input_uri.port)
        when 'tcp'
          @syslog = TCPSocket.new(@input_uri.host, @input_uri.port)
          @syslog.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, 1)
          @syslog.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, true)
        end

        setup_options
      end

      # Required by Logger::LogDevice
      #
      # @api public
      def write(message)
        begin
          @syslog.send(message, 0)
        rescue Timeout::Error => e
          STDOUT.puts "WARNING: Timeout::Error posting message: #{message}"
        end
      end

      # Required by Logger::LogDevice
      #
      # @api public
      def close
        @syslog.close
      end
    end
  end
end
