require 'helper'
include Asterisk::Mailcmd

describe Settings, "Application settings" do

  before do # setup
    @config_file = File.expand_path('fixtures/config.yml',File.dirname(__FILE__))
  end

  after do #teardown
  end

  describe "Configuration file processing" do
    it "must dump sample configuration file" do
      yaml = Settings.dump
      Psych.load(yaml).
        keys.
        include?(:template).must_equal true
    end

    it "must raise ArgumentError if config file does not exist" do
      File.stubs(:exists?).once.returns(false)
      proc {
        Settings.read('/not/existing/file.yml')
      }.must_raise ArgumentError
    end

    it "must raise ArgumentError if config file is not readable" do
      File.stubs(:exists?).once.returns(true)
      File.stubs(:readable?).once.returns(false)
      proc {
        Settings.read('/not/readable/file.yml')
      }.must_raise ArgumentError
    end

    it "must return default template" do
      Settings.read(@config_file)
      Settings.template.size.must_be :>, 0
    end

    it "must pass when default template is equale to english template" do
      Settings.read(@config_file)
      Settings.template(:en).must_equal Settings.template
    end
  end
end
