require 'helper'
include Asterisk::Mailcmd

describe Email, "setting up and delivering email" do

  before do # setup
    @html_tmpl_path = html_tmpl_file_path # helper method
    @text_tmpl_path = text_tmpl_file_path
    $stdin = mock_ast_stdin
  end

  after do #teardown
    $stdin = STDIN
  end

  describe "Setting up email" do

    it "must set email date to now" do
      email = Email.read
      # stub date
      time = Time.new
      Time.stubs(:now).returns(time)
      email.set_date
      email.mail.date.to_time. # Mail.date is DateTime class
        to_s.must_equal time.to_s
    end

    it "must set default date" do
      email = Email.read
      time = Time.now
      email.set_date time
      email.mail.date.to_time.
        to_s.must_equal time.to_s
    end

    it "must raise when invalid Time object" do
      email = Email.read
      proc {
        email.set_date "some time"
      }.must_raise ArgumentError
    end
    
    it "must return charset UTF-8 by default" do
      email = Email.read
      email.get_charset.must_equal 'UTF-8'
    end

    it "must set charset" do
      email = Email.read
      email.charset = 'ASCII'
      email.get_charset.must_equal 'ASCII'
    end

    it "must set html template with charset ISO-8859-1" do
      email = Email.read
      email.extract_vars
      email.set_date
      chrst = 'ISO-8859-1'
      email.charset = chrst
      Settings.read @text_tmpl_path, :text
      email.text_tmpl Settings.text_tmpl
      Settings.read @html_tmpl_path
      email.html_tmpl Settings.html_tmpl
      email.mail.html_part.content_type.must_match(/charset=#{chrst}/)
    end

    it "must set default deliver method and params" do
      email = Email.read
      email.delivery_method.must_equal :sendmail
      email.delivery_params.class.must_equal Hash
      email.delivery_params.size.must_equal 0
    end

    it "must raise if set_and_send has no text templates set" do
      proc {
        Email.set_and_send :charset     => 'UTF-8'
      }.must_raise InvalidTxtTmpl
    end

    it "must raise if set_and_send has no HTML templates set" do
      proc {
        Email.set_and_send :text_tmpl => @text_tmpl_path
      }.must_raise InvalidHtmlTmpl
    end

    it "must send email with set_and_send" do
      Email.stubs(:deliver).once.returns true
      Email.set_and_send  :text_tmpl => @text_tmpl_path,
                          :html_tmpl => @html_tmpl_path

    end

  end
end
