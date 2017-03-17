# Sysloggly

#### Provides a Lograge and Syslog integration for Rails apps.

## Installation

Include **sysloggly** in your Gemfile.

```ruby
gem 'sysloggly'
```

## Usage

In most cases you have to do nothing else.
However you can use `Rails.configuration.syslogger` to log output directly to `Loggly`.
