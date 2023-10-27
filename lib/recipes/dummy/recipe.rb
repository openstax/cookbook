# frozen_string_literal: true

# Hardcode locale = 'en' because CNX books contain other languages (vi, af, ru, de, ...)
# and no text is injected when baking them.
module LocaleToEnMonkeypatch
  # https://blog.appsignal.com/2021/08/24/responsible-monkeypatching-in-ruby.html
  def self.apply_patch
    Kitchen::Document.prepend(self)
  end

  def locale
    'en'
  end
end

DUMMY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :dummy) do |doc, _resources|
  include Kitchen::Directions

  # Patch locale
  LocaleToEnMonkeypatch.apply_patch
  raise "Locale is #{doc.locale}; should be 'en'" if doc.locale != 'en'

  book = doc.book
  book.search('div.test123').each { |div| div.replace_children(with: 'Hello, world!') }
end
