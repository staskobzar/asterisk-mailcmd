require 'singleton'

module Asterisk
  module Mailcmd
    class Settings
      include Singleton
      class << self

        attr :template, true

        # reading config file
        def read(file)
          raise ArgumentError, "Config file #{file} does not exists" unless File.exists? file
          raise ArgumentError, "Can not read config file #{file}" unless File.readable? file

          @template = File.read file
        end

      end
    end
  end
end
