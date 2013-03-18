require 'mail'

module Asterisk
  module Mailcmd
    class InvalidEmail < StandardError;end

    class Email
      attr_accessor :rawdata

      class << self
        # Asterisk will send generated text to STDIN
        # Read it and store in instance variable
        def read
          email = Email.new
          email.rawdata = $stdin.read
          email
        end
      end
      
      def initializes
      end

      def raw_valid?
        not @rawdata.match(/\n.\n$/).nil?
      end
    end

  end
end
