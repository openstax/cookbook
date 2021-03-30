# frozen_string_literal: true

require 'kitchen/version'

require 'nokogiri'
require 'active_support/all'

module Kitchen
  # Contains snippets of recipes that accomplish a certain medium-sized task
  module Directions; end
end

def file_glob(relative_folder_and_extension)
  Dir[File.expand_path("#{__dir__}/#{relative_folder_and_extension}")]
end

def require_all(relative_folder, file_matcher='**/*.rb')
  file_glob(relative_folder + "/#{file_matcher}").each { |f| require f }
end

require_all('kitchen/patches')
require_all('kitchen/mixins')

require 'kitchen/selectors/base'
require_all('kitchen/selectors')

require 'kitchen/utils'
require 'kitchen/transliterations'
require 'kitchen/errors'
require 'kitchen/ancestor'
require 'kitchen/search_query'
require 'kitchen/search_history'
require 'kitchen/config'
require 'kitchen/document'
require 'kitchen/book_document'
require 'kitchen/debug/print_recipe_error'
require 'kitchen/recipe'
require 'kitchen/book_recipe'
require 'kitchen/oven'
require 'kitchen/clipboard'
require 'kitchen/pantry'
require 'kitchen/counter'

require 'kitchen/element_enumerator_base'
require 'kitchen/element_enumerator_factory'
require_all('kitchen', '*enumerator.rb')

require 'kitchen/element_base'
require_all('kitchen', '*element.rb')
require 'kitchen/element_factory'

require_all('kitchen/directions')

I18n.backend.load_translations(file_glob('/locales/*.yml'))

I18n.available_locales.each do |available_locale|
  I18n.backend.store_translations(available_locale, Kitchen::TRANSLITERATIONS)
end
