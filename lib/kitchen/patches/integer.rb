# frozen_string_literal: true

# Monkey patches for +Integer+
#
class Integer

  @roman_numerals = {
    100 => 'c',
    90 => 'xc',
    50 => 'l',
    40 => 'xl',
    10 => 'x',
    9 => 'ix',
    5 => 'v',
    4 => 'iv',
    1 => 'i'
  }

  class << self
    attr_accessor :roman_numerals
  end

  # Formats as different types of integers, including roman numerals.
  #
  # @return [String]
  #
  def to_format(format)
    case format
    when :arabic
      to_s
    when :roman
      raise 'Unknown conversion to Roman numerals' if self > self.class.roman_numerals.keys.first

      to_roman
    else
      raise 'Unknown integer format'
    end
  end

  def to_roman
    return 0 if zero?

    roman = ''
    integer = self
    self.class.roman_numerals.each do |number, letter|
      until integer < number
        roman += letter
        integer -= number
      end
    end
    roman
  end
end
