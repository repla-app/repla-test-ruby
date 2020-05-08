#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'

# Test server
class TestJekyll < Minitest::Test
  JEKYLL_DIRECTORY = File.expand_path(
    File.join(__dir__, '../external/repla-test-jekyll/')
  )
  COMMAND = 'repla jekyll'.freeze
  TEST_TITLE_PREFIX = 'Your awesome title'.freeze

  def setup
    Dir.chdir(JEKYLL_DIRECTORY) do
      `#{COMMAND}`
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

  def test_jekyll
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      result && result.start_with?(TEST_TITLE_PREFIX)
    end
    assert(result.start_with?(TEST_TITLE_PREFIX))
  end
end
