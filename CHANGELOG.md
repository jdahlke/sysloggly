## Changelog

#### 0.3.2
- [new] option `ignore_user_agents` with default "Pingdom.com_bot"

#### 0.3.1
- [fix] Networklog (logging via udp)

#### 0.3.0
- refactoring Filelog client for non-blocking file access
- [new] choose between SimpleFormatter and SyslogFormatter

#### 0.2.1
- cleanup

#### 0.2.0
- complete refactoring, removed syslogger gem and added own implementation based
  on logglier
- uses file logger (default)
- able to switch to sys logger, which uses udp socket

#### 0.1.0
- initial
