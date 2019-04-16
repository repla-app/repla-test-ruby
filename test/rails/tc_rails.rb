#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'minitest/autorun'
require_relative '../lib/test_setup'

RAILS_DIRECTORY = File.expand_path(File.join(__dir__,
                                             '../../repla-test-rails-blog/'))
RAILS_COMMAND = 'bin/rails server'.freeze
RAILS_HTML_TITLE = 'Ruby on Rails'.freeze

# Test server
class TestServer < Minitest::Test
  def setup
    Dir.chdir(RAILS_DIRECTORY) do
      `#{SERVER_BUNDLE_COMMAND} "#{RAILS_COMMAND}"`
    end
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  # def teardown
  #   @window.close
  # end

  def test_rails
    # javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    # result = nil
    # Repla::Test.block_until do
    #   result = @window.do_javascript(javascript)
    #   result == RAILS_HTML_TITLE
    # end
    # assert_equal(RAILS_HTML_TITLE, result)
  end
end
