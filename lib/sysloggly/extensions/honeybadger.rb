module Sysloggly
  module Extensions
    module Honeybadger #:nodoc:
      def notify(exception_or_opts, opts = {})
        uuid = super(exception_or_opts, opts)

        if uuid
          Sysloggly.logger.error(exception_or_opts)
        end
      end
    end
  end
end

Honeybadger.singleton_class.send(:prepend, Sysloggly::Extensions::Honeybadger)
