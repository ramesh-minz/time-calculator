# frozen_string_literal: true

module TimeCalculator
  class Evaluator
    def eval(node)
      case node
      when AST::Number
        node.value
      when AST::DurationLit
        Duration.new(node.seconds)
      when AST::Binary
        a = eval(node.left)
        b = eval(node.right)
        apply(node.op, a, b)
      else
        raise EvalError, "Unknown AST node: #{node.class}"
      end
    end

    private

    def apply(op, a, b)
      # numeric vs duration coercions
      a_is_d = a.is_a?(Duration)
      b_is_d = b.is_a?(Duration)

      if !a_is_d && !b_is_d
        return a.send(op, b)
      end

      if a_is_d && b_is_d
        return a.send(op, b) if %w[+ - /].include?(op) # / => scalar ratio
        raise EvalError, "Use scalar for multiplying durations"
      end

      # one duration, one scalar
      if a_is_d && !b_is_d
        return a * b if op == "*"
        return a / b if op == "/"
        raise EvalError, "Can only add/subtract Duration with Duration"
      end

      if !a_is_d && b_is_d
        return b * a if op == "*" # scalar * duration
        raise EvalError, "Only scalar * duration supported (not #{op})"
      end

      raise EvalError, "Unsupported operation"
    end
  end
  end
