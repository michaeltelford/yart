# frozen_string_literal: true

require "test_helper"

class YartTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil YART::VERSION
  end
end
