module Sysloggly
  module Logger
    #
    # Return new Ruby logger instance configured for Sysloggly.
    #
    # @return [Logger]
    # @api public
    def self.new(url, opts = {})
      begin
        input_uri = URI.parse(url)
      rescue URI::InvalidURIError => e
        raise InvalidInputURL, "Invalid Input URL `#{url.inspect}`"
      end

      client, formatter = nil

      case input_uri.scheme
      when "file"
        client = Sysloggly::Clients::Filelog.new(input_uri.path)
        formatter = Sysloggly::Formatters::SimpleFormatter.new(input_uri, opts)
      when "udp", "tcp"
        client = Sysloggly::Clients::Networklog.new(input_uri)
        formatter = Sysloggly::Formatters::SyslogFormatter.new(input_uri, opts)
      else
        raise Sysloggly::UnsupportedScheme.new("#{input_uri.scheme} is unsupported")
      end

      logger = ::Logger.new(client)
      logger.formatter = formatter

      logger
    end
  end
end
