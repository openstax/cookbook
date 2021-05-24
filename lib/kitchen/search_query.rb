# frozen_string_literal: true

module Kitchen
  # Records the search history that was used to find a certain element
  #
  class SearchQuery
    attr_reader :css_or_xpath
    attr_reader :only
    attr_reader :except

    # Create a new SearchQuery
    #
    # @param css_or_xpath [String, Array<String>] selectors to use to limit iteration results
    #   a "$" in this argument can be replaced with a default selector via
    #   #apply_default_css_or_xpath_and_normalize
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def initialize(css_or_xpath: nil, only: nil, except: nil)
      @css_or_xpath = css_or_xpath
      @only = only.is_a?(String) ? only.to_sym : only
      @except = except.is_a?(String) ? except.to_sym : except
      @default_already_applied = false
    end

    # Returns true iff the element passes the `only` and `except` conditions
    #
    # @return [Boolean]
    #
    def conditions_match?(element)
      condition_passes?(except, element, false) && condition_passes?(only, element, true)
    end

    # Replaces '$' in the `css_or_xpath` with the provided value; also normalizes
    # `css_or_xpath` to an array.
    #
    # @param default_css_or_xpath [String, Proc, Symbol] The selectors to substitute for the "$" character
    #   when this factory is used to build an enumerator.  A string argument is used literally.  A proc
    #   is eventually called given the document's Config object (for accessing selectors).  A symbol
    #   is interpreted as the name of a selector and is called on the document's Config object's
    #   selectors object.
    #
    def apply_default_css_or_xpath_and_normalize(default_css_or_xpath=nil, config: nil)
      return if @default_already_applied

      default_css_or_xpath = [default_css_or_xpath].flatten.map do |item|
        case item
        when Proc
          item.call(config)
        when Symbol
          config.selectors.send(item)
        else
          item
        end
      end

      @as_type = nil
      @css_or_xpath = [css_or_xpath || '$'].flatten.map do |item|
        item.gsub(/\$/, default_css_or_xpath.join(', '))
      end

      @default_already_applied = true
    end

    # Returns the search query as a spaceless string suitable for use as an element type
    #
    def as_type
      @as_type ||= [
        [css_or_xpath].flatten.join(','),
        stringify_condition(only, 'only'),
        stringify_condition(except, 'except')
      ].compact.join(';')
    end

    # Returns a string representation of the search query
    #
    def to_s
      as_type
    end

    # Returns true if the query has the substitution character ('$')
    #
    def expects_substitution?
      css_or_xpath.nil? || [css_or_xpath].flatten.all? { |item| item.include?('$') }
    end

    protected

    def condition_passes?(method_or_callable, element, success_outcome)
      return true if method_or_callable.nil?

      result =
        if method_or_callable.is_a?(Symbol)
          element.send(method_or_callable)
        else
          method_or_callable.call(element)
        end

      !!result == success_outcome
    end

    def stringify_condition(condition, name)
      return nil unless condition

      "#{name}:#{condition.is_a?(Symbol) ? condition : condition.source_location.join(':')}"
    end
  end
end
