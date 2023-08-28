# frozen_string_literal: true

require 'nokogiri'
require 'active_support/all'

# Kitchen imports
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

require_relative 'kitchen/selectors/base'
require_all('kitchen/selectors')

require_relative 'kitchen/errors'
require_relative 'kitchen/utils'
require_relative 'kitchen/ancestor'
require_relative 'kitchen/search_query'
require_relative 'kitchen/search_history'
require_relative 'kitchen/config'
require_relative 'kitchen/document'
require_relative 'kitchen/book_document'
require_relative 'kitchen/debug/print_recipe_error'
require_relative 'kitchen/recipe'
require_relative 'kitchen/book_recipe'
require_relative 'kitchen/oven'
require_relative 'kitchen/clipboard'
require_relative 'kitchen/pantry'
require_relative 'kitchen/counter'
require_relative 'kitchen/selector'
require_relative 'kitchen/id_tracker'
require_relative 'kitchen/i18n_string'

require_relative 'kitchen/element_enumerator_base'
require_relative 'kitchen/element_enumerator_factory'
require_all('kitchen', '*enumerator.rb')

require_relative 'kitchen/element_base'
require_all('kitchen', '*element.rb')
require_relative 'kitchen/element_factory'

require_all('kitchen/directions')

# Setup locales
I18n.backend.load_translations(file_glob('/locales/*.yml'))

# Import recipes
require_all('recipes/**/recipe.rb', '')
require_all('recipes/**/shared.rb', '')
