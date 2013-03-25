require "asterisk/mailcmd/settings"
require "asterisk/mailcmd/email"
require "asterisk/mailcmd/version"

module Asterisk
  module Mailcmd
    include Methadone::CLILogging

    def self.run(file)
      # read email template
      Settings.read file
      # read email from STDIN
      mail = Email.read
      mail.extract_vars
      mail.html_tmpl(Settings.template)
      mail.deliver
    end

  end
end
