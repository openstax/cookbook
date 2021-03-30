# frozen_string_literal: true

module Kitchen
  # An object that yields a +Document+ for modification (those modifications are
  # the "recipe")
  #
  class Recipe

    # The document the recipe makes available for modification
    # @return [Document]
    attr_reader :document

    # The file location of the recipe
    # @return [String]
    attr_reader :source_location

    # An I18n backend specific to this recipe, may be nil
    # @return [I18n::Backend::Simple, nil]
    attr_reader :my_i18n_backend

    # Sets the document so the recipe can yield it for modification
    #
    # @param document [Document] the document to modify
    # @raise [StandardError] if not passed supported document type
    #
    def document=(document)
      @document =
        case document
        when Kitchen::Document
          document
        else
          raise "Unsupported document type `#{document.class}`"
        end
    end

    # Make a new Recipe
    #
    # @param locales_dir [String, nil] the absolute path to a folder containing recipe-specific
    #   I18n translations.  If not provided, Kitchen will look for a `locales` directory in the
    #   same directory as the recipe source.  Recipe-specific translations override those in
    #   Kitchen.  If no recipe-specific locales directory exists, Kitchen will just use its default
    #   translations.
    # @yield A block for defining the steps of the recipe
    # @yieldparam doc [Document] an object representing an XML document
    #
    def initialize(locales_dir: nil, &block)
      raise(RecipeError, 'Recipes must be initialized with a block') unless block_given?

      @source_location = block.source_location[0]
      @block = block

      load_my_i18n_backend(locales_dir)
    end

    # Executes the block given to +Recipe.new+ on the document.  Aka, does the baking.
    #
    def bake
      with_my_locales do
        @block.to_proc.call(document)
      end
    rescue RecipeError, ElementNotFoundError, Nokogiri::CSS::SyntaxError => e
      print_recipe_error_and_exit(e)
    rescue ArgumentError, NoMethodError => e
      raise unless any_stack_file_matches_source_location?(e)

      print_recipe_error_and_exit(e)
    rescue NameError => e
      raise unless stack_starts_with_source_location?(e)

      print_recipe_error_and_exit(e)
    end

    protected

    def stack_starts_with_source_location?(error)
      error.backtrace.first.start_with?(source_location)
    end

    def any_stack_file_matches_source_location?(error)
      error.backtrace.any? { |entry| entry.start_with?(@source_location) }
    end

    def load_my_i18n_backend(locales_dir)
      locales_dir ||= begin
        guessed_locales_dir = "#{File.dirname(@source_location)}/locales"
        File.directory?(guessed_locales_dir) ? guessed_locales_dir : nil
      end

      return unless locales_dir

      @my_i18n_backend = I18n::Backend::Simple.new
      @my_i18n_backend.load_translations(Dir[File.expand_path("#{locales_dir}/*.yml")])
    end

    def with_my_locales
      original_i18n_backend = I18n.backend
      I18n.backend = I18n::Backend::Chain.new(my_i18n_backend, original_i18n_backend)
      yield
    ensure
      I18n.backend = original_i18n_backend
    end

    # Print the given recipe error and do a process exit
    #
    # @param error [RecipeError] the error
    #
    def print_recipe_error_and_exit(error)
      Kitchen::Debug.print_recipe_error(error: error,
                                        source_location: source_location,
                                        document: document)
      exit(1)
    end

  end
end
