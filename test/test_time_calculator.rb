# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/time_calculator"

class TestTimeCalculator < Minitest::Test
  def test_units_addition
    r = TimeCalculator.evaluate("1h + 30m + 15s")
    assert_equal 5415, r[:seconds]
    assert_equal "01:30:15", r[:pretty]
  end

  def test_time_literal_hms
    r = TimeCalculator.evaluate("01:02:03")
    assert_equal 3723, r[:seconds]
    assert_equal "01:02:03", r[:pretty]
  end

  def test_mm_ss_autodetect
    r = TimeCalculator.evaluate("10:05") # MM:SS
    assert_equal 605, r[:seconds]
  end

  def test_hh_mm_when_not_mm_ss
    r = TimeCalculator.evaluate("70:10") # HH:MM
    assert_equal (70 * 3600 + 10 * 60), r[:seconds]
  end

  def test_parentheses_and_mul
    r = TimeCalculator.evaluate("(2h + 30m) * 3")
    assert_equal (2 * 3600 + 30 * 60) * 3, r[:seconds]
  end

  def test_duration_div_scalar
    r = TimeCalculator.evaluate("10m / 2")
    assert_equal 300, r[:seconds]
  end

  def test_duration_div_duration_ratio
    r = TimeCalculator.evaluate("90m / 30m")
    assert_in_delta 3.0, r[:scalar], 1e-9
  end

  def test_unary_minus
    r = TimeCalculator.evaluate("-10m + 2m")
    assert_equal -480, r[:seconds]
  end
end
