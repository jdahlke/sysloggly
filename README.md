# Sysloggly

#### Provides a very opinionated Lograge and Syslog integration for Rails apps.


## Installation

Include **sysloggly** in your Gemfile.

```ruby
gem 'sysloggly'
```

## Configuration

```ruby
Sysloggly.configure do |config|
  config.progname = Rails.env    # default
  config.env = Rails.env         # default

  # for filelog                  # default
  config.uri = "file://#{Rails.root.join('log','sysloggly.log')}"
  # or for syslog '[udp|tcp]://<hostname>:<port>/<facility>'
  config.uri = "udp://127.0.0.1:514/23"
end

```

## Usage

In most cases you have to do nothing else.
However you can use `Sysloggly.logger` to log output JSON directly to syslog.

```ruby
Sysloggly.logger.info({ foo: 'foo', bar: 'bar'})
```


## Thanks

Greatly inspired by the [logglier](https://github.com/freeformz/logglier) gem.
And thanks to [lograge](https://github.com/roidrage/lograge), one of the most helpful Rails gems out there.
