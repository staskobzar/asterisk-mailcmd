require 'mail'
require 'erb'

module Asterisk
  module Mailcmd
    class InvalidTxtTmpl < StandardError;end
    class InvalidHtmlTmpl < StandardError;end

    class Email
      attr_accessor :rawdata, 
                    :htmlpart,
                    :textpart,
                    :mail, 
                    :astvars,
                    :charset,
                    :delivery_method,
                    :delivery_params

      class << self
        # Asterisk will send generated text to STDIN
        # Read it and store in instance variable
        def read
          Email.new
        end

        def set_and_send params
          email = Email.read
          email.extract_vars
          email.set_date params[:date] unless params[:date].nil?
          email.charset = params[:charset] unless params[:charset].nil?
          # set templates
          raise InvalidTxtTmpl, "Text template parameter required" if params[:text_tmpl].nil?
          raise InvalidHtmlTmpl, "HTML template parameter required" if params[:html_tmpl].nil?
          Settings.read params[:text_tmpl], :text
          Settings.read params[:html_tmpl]
          email.html_tmpl Settings.html_tmpl
          email.text_tmpl Settings.text_tmpl
          # delivery
          if params[:delivery_method]
            delivery_params = params[:delivery_params] || {}
            email.set_delivery params[:delivery_method], delivery_params
          end
          email.deliver
        end
      end
      
      def initialize
        @rawdata = $stdin.read
        @mail = Mail.read_from_string(@rawdata)
        set_delivery
      end

      # Valid raw email must endin
      # with full stop (period) on new line
      def raw_valid?
        @rawdata.split.pop.eql? ?.
      end

      # extract variables from email body
      def extract_vars
        @astvars = Hash.new
        @mail.text_part.body.decoded.lines do |line|
          if /^(?<name>[^:]+):(?<val>.*)$/ =~ line.chomp
            @astvars[name.to_sym] = val
          end
        end
      end
    end

    def tmpl tmpl_text, type = :html
      tmpl = ERB.new(tmpl_text)
      raise ArgumentError, "No Asterisk variables set" if @astvars.nil?
      instance_variable_set "@#{type}part", 
        tmpl.result(binding) rescue raise ArgumentError, "Invalid type #{type.to_sym}"
    end

    def html_tmpl tmpl_text
      tmpl tmpl_text, :html
      data = @htmlpart
      cnt_type = 'text/html; charset='<<get_charset
      @mail.html_part = Mail::Part.new do
        content_type cnt_type
        body data
      end
    end

    def text_tmpl tmpl_text
      tmpl tmpl_text, :text
      data = @textpart
      @mail.text_part = Mail::Part.new do
        body data
      end
    end

    def set_date date = nil
      if date.nil?
        @mail.date Time.now 
      else
        raise ArgumentError, "Invalid date" unless date.is_a? Time
        @mail.date date
      end
    end

    def deliver
      @mail.delivery_method @delivery_method, @delivery_params
      @mail.deliver
    end
    
    def get_charset
      @charset || 'UTF-8'
    end
    
    def set_delivery method = :sendmail, params = {}
      @delivery_method = method
      @delivery_params = params
    end

  end
end
