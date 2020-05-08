#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'

# Test server
class TestJekyll < Minitest::Test
  JEKYLL_DIRECTORY = File.expand_path(
    File.join(__dir__, '../external/repla-test-jekyll/')
  )
  JEKYLL_DIRECTORY_ARCHITECT = File.expand_path(
    File.join(__dir__, '../external/repla-test-jekyll-architect/')
  )
  TEST_TITLE_PREFIX = 'Your awesome title'.freeze
  TEST_TITLE_PREFIX_ARCHITECT = 'Architect theme'.freeze
  COMMAND = 'repla jekyll'.freeze

  def test_jekyll
    Dir.chdir(JEKYLL_DIRECTORY) do
      `#{COMMAND}`
    end
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    window = Repla::Window.new(window_id)
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = window.do_javascript(javascript)
      result && result.start_with?(TEST_TITLE_PREFIX)
    end
    assert(result.start_with?(TEST_TITLE_PREFIX))
    window.close
  end

  def test_jekyll_architect
    Dir.chdir(JEKYLL_DIRECTORY_ARCHITECT) do
      `#{COMMAND}`
    end
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    window = Repla::Window.new(window_id)
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = window.do_javascript(javascript)
      result && result.start_with?(TEST_TITLE_PREFIX_ARCHITECT)
    end
    assert(result.start_with?(TEST_TITLE_PREFIX_ARCHITECT))
    window.close
  end
end
