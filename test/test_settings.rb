require 'helper'
include Asterisk::Mailcmd

describe Settings, "Application settings" do

  before do # setup
    @tmpl_path = tmpl_file_path # helper method
  end

  after do #teardown
  end

  describe "Settings processing" do

    it "must raise ArgumentError if template file does not exist" do
      File.stubs(:exists?).once.returns(false)
      proc {
        Settings.read('/not/existing/file.yml')
      }.must_raise ArgumentError
    end

    it "must raise ArgumentError if template file is not readable" do
      File.stubs(:exists?).once.returns(true)
      File.stubs(:readable?).once.returns(false)
      proc {
        Settings.read('/not/readable/file.yml')
      }.must_raise ArgumentError
    end

    it "must set instance variable after reading template file" do
      Settings.read(@tmpl_path).must_equal Settings.template
    end

  end
end
