require 'minitest/autorun'
require 'mocha/setup'
require 'stringio'
require 'methadone'
require 'asterisk/mailcmd'

class MiniTest::Unit::TestCase
  def mock_ast_stdin
    # get raw email from fixture file
    file = File.expand_path('fixtures/email.text',File.dirname(__FILE__))
    # return mocked IO
    StringIO.new(File.read file)
  end

  def tmpl_file_path
    File.expand_path('fixtures/template.erb',File.dirname(__FILE__))
  end

end
