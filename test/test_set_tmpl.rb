require 'helper'
include Asterisk::Mailcmd

describe Email, "Body templates" do

  before do # setup
    @html_tmpl_path = html_tmpl_file_path # helper method
    @text_tmpl_path = text_tmpl_file_path
    $stdin = mock_ast_stdin
  end

  after do #teardown
    $stdin = STDIN
  end

  describe "Setting up email variables and templates" do

    it "must extract Asterisk variables from email" do
      email = Email.read
      email.extract_vars
      # see fixtures for expected values
      email.astvars[:VM_CIDNUM].must_equal "2275550168"
    end

    it "must set email HTML tamplate and inline variables" do
      email = Email.read
      email.extract_vars
      Settings.read @html_tmpl_path
      email.html_tmpl Settings.html_tmpl
      email.htmlpart.must_match(email.astvars[:VM_CIDNUM])
      email.mail.html_part.body.decoded.
        must_match(email.astvars[:VM_CIDNUM])
    end

    it "must raise if variables were not extracted" do
      proc {
        email = Email.read
        Settings.read @html_tmpl_path
        email.html_tmpl Settings.html_tmpl
      }.must_raise ArgumentError
    end

    it "must raise if invalid template type" do
      proc {
        email = Email.read
        email.tmpl "template text", :unknown_type
      }.must_raise ArgumentError
    end

    it "must set email TEXT tamplate and inline variables" do
      email = Email.read
      email.extract_vars
      Settings.read @text_tmpl_path, :text
      email.text_tmpl Settings.text_tmpl
      email.textpart.must_match(email.astvars[:VM_CIDNUM])
      email.mail.text_part.body.decoded.
        must_match(email.astvars[:VM_CIDNUM])
    end

  end
end
