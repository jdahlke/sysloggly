require "socket"

module Sysloggly
  module Clients
    class Networklog
      attr_reader :input_uri, :socket

      # Creates a new client that conforms to the Logger::LogDevice specification.
      #
      # @return [Sysloggly::Client::Networklog]
      # @api public
      def initialize(input_uri)
        @input_uri = input_uri

        case @input_uri.scheme
        when "udp"
          @socket = UDPSocket.new
          @socket.connect(@input_uri.host, @input_uri.port)
        when "tcp"
          @socket = TCPSocket.new(@input_uri.host, @input_uri.port)
          @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, 1)
          @socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, true)
        end
      end

      # Required by Logger::LogDevice
      #
      # @api public
      def write(message)
        begin
          @socket.send(message, 0)
        rescue Timeout::Error => e
          STDOUT.puts "WARNING: Timeout::Error posting message: #{message}"
        end
      end

      # Required by Logger::LogDevice
      #
      # @api public
      def close
        @socket.close
      end
    end
  end
end
