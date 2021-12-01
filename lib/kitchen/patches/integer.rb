# frozen_string_literal: true

# Monkey patches for +Integer+
#
class Integer
  ROMAN_NUMERALS = %w[0 i ii iii iv v vi vii viii ix
                      x xi xii xiii xiv xv xvi xvii xviii xix
                      xx xxi xxii xxiii xxiv xxv xxvi xxvii xxviii xxix
                      xxx xxxi xxxii xxxiii xxxiv xxxv xxxvi xxxvii xxxviii xxxix].freeze

  # Formats as different types of integers, including roman numerals.
  #
  # @return [String]
  #
  def to_format(format)
    case format
    when :arabic
      to_s
    when :roman
      raise 'Unknown conversion to Roman numerals' if self >= ROMAN_NUMERALS.size

      ROMAN_NUMERALS[self]
    else
      raise 'Unknown integer format'
    end
  end
end
