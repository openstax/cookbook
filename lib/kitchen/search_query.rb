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
    end

    # Returns true iff the element passes the `only` and `except` conditions
    #
    # @return [Boolean]
    #
    def conditions_match?(element)
      condition_passes?(except, element, false) && condition_passes?(only, element, true)
    end

    # Replaces '$' in the `css_or_xpath` with the provided value; also normalizes
    # `css_or_xpath` to an array
    #
    def apply_default_css_or_xpath_and_normalize(default_css_or_xpath=nil)
      @as_type = nil
      @css_or_xpath = [css_or_xpath || '$'].flatten.map do |item|
        item.gsub(/\$/, [default_css_or_xpath].flatten.join(', '))
      end
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
