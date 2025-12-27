# frozen_string_literal: true

module TimeCalculator
  class Error < StandardError; end
  class ParseError < Error; end
  class EvalError < Error; end

  class Duration
    attr_reader :seconds

    def initialize(seconds)
      @seconds = seconds.to_i
    end

    def +(other)
      raise EvalError, "Cannot add Duration with #{other.class}" unless other.is_a?(Duration)
      Duration.new(@seconds + other.seconds)
    end

    def -(other)
      raise EvalError, "Cannot subtract Duration with #{other.class}" unless other.is_a?(Duration)
      Duration.new(@seconds - other.seconds)
    end

    def *(scalar)
      raise EvalError, "Duration can only be multiplied by a scalar" unless scalar.is_a?(Numeric)
      Duration.new((@seconds * scalar).round)
    end

    def /(other)
      if other.is_a?(Numeric)
        raise EvalError, "Division by zero" if other == 0
        Duration.new((@seconds / other).round)
      elsif other.is_a?(Duration)
        raise EvalError, "Division by zero duration" if other.seconds == 0
        @seconds.to_f / other.seconds.to_f
      else
        raise EvalError, "Duration can only be divided by scalar or duration"
      end
    end

    def pretty
      s = @seconds
      sign = s < 0 ? "-" : ""
      s = s.abs

      days = s / 86_400
      s %= 86_400
      hours = s / 3600
      s %= 3600
      mins = s / 60
      secs = s % 60

      base = format("%02d:%02d:%02d", hours, mins, secs)
      days > 0 ? "#{sign}#{days}d #{base}" : "#{sign}#{base}"
    end

    def to_h
      { seconds: @seconds, pretty: pretty }
    end
  end
end
