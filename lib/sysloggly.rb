require "logger"
require "lograge"
require "uri"

require "sysloggly/version"
require "sysloggly/clients/filelog"
require "sysloggly/clients/networklog"
require "sysloggly/formatters/simple_formatter"
require "sysloggly/formatters/syslog_formatter"

#
# Sysloggly
#
# @config [uri] only supports [udp|tcp|file]
module Sysloggly
  class InputURLRequired < ArgumentError; end
  class UnsupportedScheme < ArgumentError; end
  class UnknownFacility < ArgumentError; end

  mattr_accessor :progname, :env, :uri, :logger

  def self.configure
    yield self
  end


  # Creates a new logger instance
  #
  # @return [Logger]
  # @api public
  def self.new(url, opts = {})
    raise InputURLRequired.new  unless url

    begin
      input_uri = URI.parse(url)
    rescue URI::InvalidURIError => e
      raise InputURLRequired.new("Invalid Input URL: #{url}")
    end

    client, formatter = nil

    case input_uri.scheme
    when "file"
      client = Sysloggly::Clients::Filelog.new(input_uri.path)
      formatter = Sysloggly::Formatters::SimpleFormatter.new(input_uri, opts)
    when "udp", "tcp"
      client = Sysloggly::Clients::Networklog.new(input_uri, opts)
      formatter = Sysloggly::Formatters::SyslogFormatter.new(input_uri, opts)
    else
      raise Sysloggly::UnsupportedScheme.new("#{input_uri.scheme} is unsupported")
    end

    logger = Logger.new(client)
    logger.formatter = formatter

    logger
  end
end

require "sysloggly/rails"  if Object.const_defined?(:Rails) && Rails.const_defined?(:Railtie)
