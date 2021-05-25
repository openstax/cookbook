# frozen_string_literal: true

require 'twitter_cldr'

# rubocop:disable Style/Documentation
module I18n
  def self.sort_strings(first, second)
    string_sorter.compare(first, second)
  end

  def self.string_sorter
    @string_sorter ||= begin
      # TwitterCldr does not know about our :test locale, so substitute the English one
      locale = I18n.locale == :test ? :en : I18n.locale
      TwitterCldr::Collation::Collator.new(locale)
    end
  end

  def self.clear_string_sorter
    @string_sorter = nil
  end

  class <<self
    alias_method :original_locale=, :locale=
  end

  def self.locale=(locale)
    # We wrap the setting of locale so that we can clear the string sorter (so that it
    # gets reset to the new locale the next time it is used)
    clear_string_sorter
    self.original_locale = locale
  end
end
# rubocop:enable Style/Documentation
