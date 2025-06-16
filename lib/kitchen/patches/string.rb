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

  # Transform self to kebab case, returning a new string
  # Example: "Star Wars: The Empire Strikes Back" -> "star-wars-the-empire-strikes-back"
  #
  # @return [String]
  #
  def slugify
    I18n.transliterate(
      strip.downcase
        .gsub(/'/, '')
        .gsub(/®/, ' r')
        .gsub(/\u2014+/, '-')
    ).gsub(/[^(\w\s)-]/, '').gsub(/[\s-]+/, '-')
  end
end
