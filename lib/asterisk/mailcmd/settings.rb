require 'singleton'
require 'psych'

module Asterisk
  module Mailcmd
    class Settings
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
      include Singleton
      class << self
        # dump default configuration to yaml format
        def dump
          CONFIG.to_yaml
        end
        # reading config file
        def read(file)
          @conf = ''
        end
      end
    end
  end
end
