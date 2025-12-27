# frozen_string_literal: true

module TimeCalculator
  class Parser
    PRECEDENCE = { "+" => 1, "-" => 1, "*" => 2, "/" => 2 }.freeze

    def initialize(tokens)
      @tokens = tokens
      @pos = 0
    end

    def parse
      expr = parse_expression(0)
      raise ParseError, "Unexpected token #{peek.type}" if peek
      expr
    end

    private

    def parse_expression(min_prec)
      left = parse_primary

      while (tok = peek) && tok.type == :op && PRECEDENCE[tok.value] >= min_prec
        op = tok.value
        prec = PRECEDENCE[op]
        consume(:op)
        right = parse_expression(prec + 1)
        left = AST::Binary.new(op, left, right)
      end

      left
    end

    def parse_primary
      tok = peek
      raise ParseError, "Unexpected end of input" unless tok

      case tok.type
      when :number
        consume(:number)
        AST::Number.new(tok.value)
      when :duration
        consume(:duration)
        AST::DurationLit.new(tok.value)
      when :lparen
        consume(:lparen)
        node = parse_expression(0)
        consume(:rparen)
        node
      else
        raise ParseError, "Unexpected token #{tok.type}"
      end
    end

    def peek
      @tokens[@pos]
    end

    def consume(type)
      tok = peek
      raise ParseError, "Expected #{type}, got #{tok&.type || 'EOF'}" unless tok && tok.type == type
      @pos += 1
      tok
    end
  end
end
