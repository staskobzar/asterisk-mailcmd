require 'helper'
include Asterisk::Mailcmd

describe Email, "reading email data from Asterisk" do

  before do # setup
    $stdin = mock_ast_stdin
  end

  after do #teardown
    $stdin = STDIN
  end

  describe "Reading from Asterisk" do

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
        must_equal "asterisk@localhost.localdomain"
    end

  end
end
