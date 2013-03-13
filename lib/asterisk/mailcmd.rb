require "asterisk/mailcmd/settings"
require "asterisk/mailcmd/version"

module Asterisk
  module Mailcmd

    def self.run(opt)
      unless opt[:print].nil?
        case opt[:print]
        when 'config'
          puts Settings.dump
        end

        exit(0)
      end
      debug("Reading config file")
      Asterisk::Mailcmd::Settings.init options[:config]
    end
  end
end
