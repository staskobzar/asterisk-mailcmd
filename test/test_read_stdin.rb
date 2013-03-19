require 'helper'
include Asterisk::Mailcmd

describe Settings, "Application settings" do

  before do # setup
    @tmpl_path = tmpl_file_path # helper method
    $stdin = mock_ast_stdin
  end

  after do #teardown
    $stdin = STDIN
  end

  describe "Settings processing" do

    it "must read valid raw email from STDIO" do
      email = Email.read
      email.rawdata.size.must_be :>, 0
    end

    it "must return false if invalid raw email message" do
      # Valid raw email must endin
      # with full stop (period) on new line
      # RFC772: The last line must consist of only a single period.
      $stdin.stubs(:read).once.returns("This is invalid \n.\nraw email")
      email = Email.read
      email.raw_valid?.must_equal false
    end

    it "must return true if valid raw email" do
      email = Email.read
      email.raw_valid?.must_equal true
    end

    it "must read mail to Mail class instance" do
      Email.read.
        mail.from.first.
        must_equal "voicemail@asterisk.org"
    end

    it "must extract Asterisk variables from email" do
      email = Email.read
      email.extract_vars
      email.astvars[:VM_CIDNUM].must_equal "2275550168"
    end

    it "must set email tamplate and inline variables" do
      Settings.read @tmpl_path
      email = Email.read
      email.set_tmpl Settings.template
      email.htmlpart.must_match(email.astvars[:VM_CIDNUM])
      email.deliver
    end
  end
end
