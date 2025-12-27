# frozen_string_literal: true

module TimeCalculator
  Token = Struct.new(:type, :value) do
    def to_s = "#{type}(#{value.inspect})"
  end

  class Tokenizer
    UNIT_SECONDS = { "d" => 86_400, "h" => 3600, "m" => 60, "s" => 1 }.freeze
    OPERATORS = %w[+ - * /].freeze

    def initialize(input)
      @s = input.to_s.strip
      @i = 0
      @tokens = []
      @prev = nil
    end

    def tokens
      while @i < @s.length
        ch = @s[@i]

        if ch =~ /\s/
          @i += 1
          next
        end

        if ch == "("
          push(:lparen, ch)
          @i += 1
          next
        end

        if ch == ")"
          push(:rparen, ch)
          @i += 1
          next
        end

        if OPERATORS.include?(ch)
          # unary minus -> rewrite as 0 - expr
          if ch == "-" && (@prev.nil? || @prev == :op || @prev == :lparen)
            push(:number, 0.0)
            push(:op, "-")
            @i += 1
            next
          end

          push(:op, ch)
          @i += 1
          next
        end

        if ch =~ /[0-9.]/
          read_number_or_time_or_unit
          next
        end

        raise ParseError, "Unexpected character '#{ch}' at position #{@i}"
      end

      @tokens
    end

    private

    def push(type, value)
      @tokens << Token.new(type, value)
      @prev = type
    end

    def read_number_or_time_or_unit
      j = @i
      while j < @s.length && @s[j] =~ /[0-9.:]/
        j += 1
      end
      chunk = @s[@i...j]

      if chunk.include?(":")
        push(:duration, parse_time_literal(chunk))
        @i = j
        return
      end

      raise ParseError, "Invalid number '#{chunk}'" unless chunk =~ /\A\d+(\.\d+)?\z/
      num = chunk.to_f

      k = j
      if k < @s.length && @s[k] =~ /[dhms]/
        total = 0.0

        loop do
          unit = @s[k]
          raise ParseError, "Unknown unit '#{unit}'" unless UNIT_SECONDS.key?(unit)
          total += num * UNIT_SECONDS[unit]
          k += 1

          # allow spaces between segments
          k += 1 while k < @s.length && @s[k] =~ /\s/

          # parse next <number><unit> segment if present
          break unless k < @s.length && @s[k] =~ /[0-9.]/

          k2 = k
          while k2 < @s.length && @s[k2] =~ /[0-9.]/
            k2 += 1
          end
          n2 = @s[k...k2]
          break unless n2 =~ /\A\d+(\.\d+)?\z/
          num = n2.to_f
          k = k2

          break unless k < @s.length && @s[k] =~ /[dhms]/
        end

        push(:duration, total.round)
        @i = k
        return
      end

      push(:number, num)
      @i = j
    end

    # Supports:
    #  - HH:MM
    #  - MM:SS (auto-detect if both <= 59)
    #  - HH:MM:SS
    def parse_time_literal(str)
      parts = str.split(":")
      raise ParseError, "Bad time literal '#{str}'" unless parts.all? { |p| p =~ /\A\d+\z/ }
      ints = parts.map(&:to_i)

      case ints.length
      when 2
        a, b = ints
        if a <= 59 && b <= 59
          (a * 60) + b # MM:SS
        else
          (a * 3600) + (b * 60) # HH:MM
        end
      when 3
        h, m, s = ints
        raise ParseError, "Minutes/seconds must be 0..59 in '#{str}'" if m > 59 || s > 59
        (h * 3600) + (m * 60) + s
      else
        raise ParseError, "Bad time literal '#{str}'"
      end
    end
  end
  end
