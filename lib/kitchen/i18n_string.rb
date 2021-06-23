# frozen_string_literal: true

module Kitchen
  # Compare one string with another
  #
  # Returns 0 if first string equals second,
  # 1 if first string is greater than the second
  # and -1 if first string is less than the second.
  #
  class I18nString < String

    def <=>(other)
      I18n.sort_strings(self, other)
    end
  end
end
