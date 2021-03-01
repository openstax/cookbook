# frozen_string_literal: true
module Kitchen
  # Records the search history that was used to find a certain element
  #
  class SearchHistory
    attr_reader :latest
    attr_reader :upstream

    # Returns an empty search history
    #
    # @return [SearchHistory]
    #
    def self.empty
      new
    end

    # Returns a new +SearchHistory+ that contains the current selector history plus the
    # provided selector
    #
    # @param css_or_xpath [String] the selector history to add
    # @return [SearchHistory]
    #
    def add(css_or_xpath)
      self.class.new(self, css_or_xpath.nil? ? nil : [css_or_xpath].join(', '))
    end

    # Returns the history as a string
    #
    # @param missing_string [String] if there's a missing part of the history, this string
    #   is used in its place
    # @return [String]
    #
    def to_s(missing_string='?')
      to_a.map { |item| "[#{item || missing_string}]" }.join(' ')
    end

    # Returns this instance as an array of selectors
    #
    # @return [Array<String>]
    #
    def to_a
      empty? ? [] : [upstream&.to_a || [], latest].flatten
    end

    # Returns true if the search history is empty
    #
    # @return [Boolean]
    #
    def empty?
      upstream.nil? && latest.nil?
    end

    protected

    # Create a new instance
    #
    # @param upstream [SearchHistory] prior search history
    # @param latest [String] the new history
    #
    def initialize(upstream=nil, latest=nil)
      @upstream = upstream
      @latest = latest
    end
  end
end
