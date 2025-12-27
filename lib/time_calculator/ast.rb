# frozen_string_literal: true

module TimeCalculator
  module AST
    class Node; end

    class Number < Node
      attr_reader :value
      def initialize(value) = @value = value.to_f
    end

    class DurationLit < Node
      attr_reader :seconds
      def initialize(seconds) = @seconds = seconds.to_i
    end

    class Binary < Node
      attr_reader :op, :left, :right
      def initialize(op, left, right)
        @op, @left, @right = op, left, right
      end
    end
  end
    end
