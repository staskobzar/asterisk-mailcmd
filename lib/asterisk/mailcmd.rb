require "asterisk/mailcmd/settings"
require "asterisk/mailcmd/version"

module Asterisk
  module Mailcmd
    include Methadone::CLILogging

    def self.run(opt)
      file = opt[:config]
      debug("Reading config file")
      Asterisk::Mailcmd::Settings.read file
    end

    def self.print(opt)
      case opt
      when 'config'
        puts Settings.dump
      when 'tmpl'
        puts "TODO: file template"
      end
    end
  end
end
