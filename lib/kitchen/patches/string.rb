# frozen_string_literal: true

# Monkey patches for +String+
#
class String
  # Downcases the first letter of self, returning a new string
  #
  # @return [String]
  #
  def uncapitalize
    sub(/^[A-Z]/, &:downcase)
  end

  def kebab_case
    strip.downcase.gsub(/[^(\w\s)]/, '').gsub(/\s/, '-')
  end
end
