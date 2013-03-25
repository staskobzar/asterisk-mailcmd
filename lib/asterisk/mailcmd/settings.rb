require 'singleton'

module Asterisk
  module Mailcmd
    class Settings
      include Singleton
      class << self

        attr :html_tmpl, true
        attr :text_tmpl, true

        # reading config file
        def read(file, type = :html)
          raise ArgumentError, "Config file #{file} does not exists" unless File.exists? file
          raise ArgumentError, "Can not read config file #{file}" unless File.readable? file

          case type 
          when :html
            @html_tmpl = File.read file
          when :text
            @text_tmpl = File.read file
          else
            raise ArgumentError, "Invalid template type :#{type.to_s}"
          end
        end

      end
    end
  end
end
