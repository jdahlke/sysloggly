require 'logger'
require 'lograge'

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

  def self.new(url, opts = {})
    client = Sysloggly::Client.new(url, opts)
    logger = Logger.new(client)

    if client.respond_to?(:formatter)
      logger.formatter = client.formatter
    elsif client.respond_to?(:datetime_format)
      logger.datetime_format = client.datetime_format
    end

    logger
  end
end

require 'sysloggly/version'
require 'sysloggly/client'
require 'sysloggly/client/filelog'
require 'sysloggly/client/syslog'
require 'sysloggly/rails'  if Object.const_defined?(:Rails) && Rails.const_defined?(:Railtie)
