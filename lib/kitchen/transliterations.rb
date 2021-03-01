# frozen_string_literal: true

module Kitchen
  # These are added to every translation locale, including the `test` locale
  # set by `stub_locales`.  When we sort strings with accent marks, we use
  # `ActiveSupport::Inflector.transliterate` to ensure that the sorting is
  # sensible.  This method does not know about Greek characters by default so
  # we teach it about them by adding the rules below to the i18n configuration.
  #
  TRANSLITERATIONS = {
    i18n: {
      transliterate: {
        rule: {
          σ: 'σ',
          Δ: 'Δ',
          π: 'π'
        }
      }
    }
  }.freeze
end
