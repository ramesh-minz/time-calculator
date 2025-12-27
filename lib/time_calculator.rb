# frozen_string_literal: true

require_relative "time_calculator/version"
require_relative "time_calculator/duration"
require_relative "time_calculator/tokenizer"
require_relative "time_calculator/ast"
require_relative "time_calculator/parser"
require_relative "time_calculator/evaluator"

module TimeCalculator
  module_function

  # Returns:
  # - {seconds:, pretty:} for duration results
  # - {scalar:} for scalar results
  def evaluate(expression)
    tokens = Tokenizer.new(expression).tokens
    ast = Parser.new(tokens).parse
    value = Evaluator.new.eval(ast)

    if value.is_a?(Duration)
      value.to_h
    else
      { scalar: value }
    end
  end
end
