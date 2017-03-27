module Sysloggly
  module Client
    class Filelog
      include Sysloggly::Client::InstanceMethods

      attr_reader :input_uri, :opts
      attr_reader :filelog

      def initialize(input_uri, opts)
        @input_uri = input_uri
        @opts = opts

        @filelog = File.open(@input_uri.path, File::WRONLY | File::APPEND | File::CREAT)

        setup_options
      end



      # Required by Logger::LogDevice
      #
      # @api public
      def write(message)
        @filelog.write(message)
      end

      # Required by Logger::LogDevice
      #
      # @api public
      def close
        @filelog.close
      end
    end
  end
end
