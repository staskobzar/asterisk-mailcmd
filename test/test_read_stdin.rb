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
      # with dot and new line "\n.\n"
      # RFC772: The last line must consist of only a single period.
      $stdin.stubs(:read).once.returns("This is invalid raw email")
      email = Email.read
      email.raw_valid?.must_equal false
    end

    it "must return true if valid raw email" do
      email = Email.read
      email.raw_valid?.must_equal true
    end
  end
end
