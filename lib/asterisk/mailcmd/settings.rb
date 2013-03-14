require 'singleton'
require 'psych'

module Asterisk
  module Mailcmd
    class Settings
      include Singleton
      # default configuration settings
      CONFIG = {
        :template => {
          :en   => '/etc/asterisk/vmtmpl/email-en.erb',
          :fr   => '/etc/asterisk/vmtmpl/email-fr.erb',
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

        # default template
        def template lang=:en
          raise ArgumentError, 
            "Template not found" if @conf[:template][lang].nil?
          @conf[:template][lang]
        end
      end
    end
  end
end
