require 'singleton'
require 'psych'

module Asterisk
  module Mailcmd
    class Settings
      include Singleton
      # default configuration settings
      CONFIG = {
        :template => {
          :en   => {
            :erb  => '/etc/asterisk/vmtmpl/email-en.erb',
            :haml => '/etc/asterisk/vmtmpl/email-en.haml',
          },
          :fr   => {
            :erb  => '/etc/asterisk/vmtmpl/email-fr.erb',
            :haml => '/etc/asterisk/vmtmpl/email-fr.haml',
          },
        }
      }
      class << self
        # dump default configuration to yaml format
        def dump
          CONFIG.to_yaml
        end
        # reading config file
        def read(file)
          raise ArgumentError, "Config file #{file} does not exists" unless File.exists? file
          raise ArgumentError, "Can not read config file #{file}" unless File.readable? file

          @conf = Psych.load_file file
        end
      end
    end
  end
end
