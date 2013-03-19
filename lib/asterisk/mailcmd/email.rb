require 'mail'
require 'erb'

module Asterisk
  module Mailcmd
    class InvalidEmail < StandardError;end

    class Email
      attr_accessor :rawdata, :htmlpart, :mail, :astvars

      class << self
        # Asterisk will send generated text to STDIN
        # Read it and store in instance variable
        def read
          email = Email.new
          email.rawdata = $stdin.read
          email.mail = Mail.read_from_string(email.rawdata)
          email
        end
      end
      
      def initializes
      end

      # Valid raw email must endin
      # with full stop (period) on new line
      def raw_valid?
        @rawdata.split.pop.eql? ?.
      end

      # extract variables from email body
      def extract_vars
        vars = Hash.new
        @mail.text_part.body.decoded.lines do |line|
          if /^(?<name>[^:]+):(?<val>.*)$/ =~ line.chomp
            vars[name.to_sym] = val
          end
        end
        @astvars = vars
      end
    end

    def set_tmpl tmpl_text
      tmpl = ERB.new(tmpl_text)
      extract_vars
      @htmlpart = tmpl.result(binding)
    end

    def deliver
      @mail.delivery_method :sendmail
      @mail.text_part.content_type 'text/html; charset=UTF-8'
      pp @mail.text_part.body
      #@mail.deliver do
      #  html_part do
      #    content_type 'text/html; charset=UTF-8'
      #    body @htmlpart
      #  end
      #end
    end
  end
end
