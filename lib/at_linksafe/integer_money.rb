module AtLinksafe
  module IntegerMoney

    FloatPoint = 0.0000001

    # thanks http://www.hans-eric.com/code-samples/ruby-floating-point-round-off/
    def round_to_two( flt )
      (flt.to_f * 10**2).round.to_f / 10**2
    end

    def string_to_dollars(dollar_str)
      raise RuntimeError, "#{dollar_str} is not a string." unless 'String' == dollar_str.class.name
      if ['0', '0.0', '0.00'].include?(dollar_str)
        0
      elsif dollar_str.include?('.')
        round_to_two(dollar_str)
      else
        dollar_str.to_i
      end
    end

    def cents_to_dollars(cents)
      cents = cents.to_i if cents.is_a?(String)
      cents == 0 ? 0 : cents/100.0
    end

    def dollars_to_cents(amount)
      case amount.class.name
      when 'String'
        amount = string_to_dollars(amount)
      when 'Float'
        amount += FloatPoint # (9.95*100).to_i == 994 !!
      when 'Integer', 'Fixnum'
        #      amount = amount.to_i
      else
        raise RuntimeError, "amount is type #{amount.class.name}"
      end
      (amount * 100).round
    end

  end
end
