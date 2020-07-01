require "kitchen/version"

require "nokogiri"
require "active_support/all"

module Kitchen
end

def file_glob(relative_folder_and_extension)
  Dir[File.expand_path(__dir__ + "/" + relative_folder_and_extension)]
end

def require_all(relative_folder, file_matcher="*.rb")
  file_glob(relative_folder + "/#{file_matcher}").each{|f| require f}
end

require_all("kitchen/mixins")

require "kitchen/utils"
require "kitchen/errors"
require "kitchen/ancestor"
require "kitchen/element_enumerator"
require "kitchen/element_enumerator_factory"
require "kitchen/page_element_enumerator"
require "kitchen/term_element_enumerator"
require "kitchen/chapter_element_enumerator"
require "kitchen/book_element_enumerator"
require "kitchen/figure_element_enumerator"
require "kitchen/table_element_enumerator"
require "kitchen/example_element_enumerator"
require "kitchen/element_base"
require "kitchen/element"
require "kitchen/book_element"
require "kitchen/chapter_element"
require "kitchen/example_element"
require "kitchen/page_element"
require "kitchen/term_element"
require "kitchen/figure_element"
require "kitchen/table_element"
require "kitchen/note_element"
require "kitchen/document"
require "kitchen/book_document"
require "kitchen/debug/print_recipe_error"
require "kitchen/recipe"
require "kitchen/book_recipe"
require "kitchen/oven"
require "kitchen/clipboard"
require "kitchen/pantry"
require "kitchen/counter"
require "kitchen/note_element_enumerator"
require "kitchen/patches"

require_all("kitchen/directions")

I18n.load_path << file_glob("/locales/*.yml")
