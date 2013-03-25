require 'helper'
include Asterisk::Mailcmd

describe Settings, "Application settings" do

  before do # setup
    # helper methods
    @html_tmpl_path = html_tmpl_file_path 
    @text_tmpl_path = text_tmpl_file_path
  end

  after do #teardown
  end

  describe "Settings processing" do

    it "must raise ArgumentError if template file does not exist" do
      File.stubs(:exists?).once.returns(false)
      proc {
        Settings.read('/not/existing/file.tmpl')
      }.must_raise ArgumentError
    end

    it "must raise ArgumentError if template file is not readable" do
      File.stubs(:exists?).once.returns(true)
      File.stubs(:readable?).once.returns(false)
      proc {
        Settings.read('/not/readable/file.tmpl')
      }.must_raise ArgumentError
    end

    it "must set instance variable after reading html template file" do
      Settings.read(@html_tmpl_path, :html).must_equal Settings.html_tmpl
    end

    it "must set instance variable after reading text template file" do
      Settings.read(@text_tmpl_path, :text).must_equal Settings.text_tmpl
    end

    it "must set default template as html" do
      Settings.read(@html_tmpl_path, :html).must_equal Settings.read(@html_tmpl_path)
    end

    it "must raise ArgumentError when template type is invalid" do
      proc {
        Settings.read(@html_tmpl_path, :unknown_template_type)
      }.must_raise ArgumentError
    end

  end
end
