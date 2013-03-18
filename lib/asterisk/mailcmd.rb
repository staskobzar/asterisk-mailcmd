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
      Email.read.
        set_tmpl(Settings.template).
        send

    end

  end
end
