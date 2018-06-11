require "logger"
require "lograge"
require "uri"

require "sysloggly/version"
require "sysloggly/clients/filelog"
require "sysloggly/clients/networklog"
require "sysloggly/formatters/simple_formatter"
require "sysloggly/formatters/syslog_formatter"
require "sysloggly/logger"

#
# Sysloggly
#
# @config [uri] only supports [udp|tcp|file]
module Sysloggly
  class InvalidInputURL < ArgumentError; end
  class UnsupportedScheme < ArgumentError; end
  class UnknownFacility < ArgumentError; end

  mattr_accessor :progname, :env, :uri
  mattr_accessor :logger
  mattr_accessor :ignore_user_agents

  def self.configure
    yield self
  end
end

#
# load extensions
#
if Object.const_defined?(:Rails) && Rails.const_defined?(:Railtie)
  require "sysloggly/rails"
end
if defined?(Honeybadger)
  require 'sysloggly/extensions/honeybadger'
end
