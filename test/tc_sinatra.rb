#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby --disable-gems

require 'minitest/autorun'
require_relative 'lib/test_setup'

# Test server
class TestServer < Minitest::Test
  EXTERNAL_DIRECTORY = File.expand_path(
    File.join(__dir__, '../external/repla-test-sinatra/')
  )
  EXTERNAL_COMMAND = 'bundle exec ruby myapp.rb'.freeze
  HTML_BODY = 'Hello world!'.freeze

  def setup
    Dir.chdir(EXTERNAL_DIRECTORY) do
      `#{SERVER_BUNDLE_COMMAND} "#{EXTERNAL_COMMAND}"`
    end
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
  end

  def test_rails
    javascript = File.read(Repla::Test::BODY_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      result == HTML_BODY
    end
    assert_equal(HTML_BODY, result)
  end
end
