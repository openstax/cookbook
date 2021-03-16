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

    # Returns a new +SearchHistory+ that contains the current history plus the
    # provided query
    #
    # @param search_query [SearchQuery] the search query to add to the history
    # @return [SearchHistory]
    #
    def add(search_query)
      search_query = SearchQuery.new(css_or_xpath: search_query) if search_query.is_a?(String)
      self.class.new(self, search_query)
    end

    # Returns the history as a string
    #
    # @param missing_string [String] if there's a missing part of the history, this string
    #   is used in its place
    # @return [String]
    #
    def to_s(missing_string='?')
      array = to_a
      array.shift while array.any? && array[0].nil?
      array.map { |item| "[#{item || missing_string}]" }.join(' ')
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
    # @param latest [SearchQuery] the new history
    #
    def initialize(upstream=nil, latest=nil)
      raise 'Upstream must be a SearchHistory' unless upstream.nil? || upstream.is_a?(SearchHistory)
      raise 'Latest must be a SearchQuery' unless latest.nil? || latest.is_a?(SearchQuery)

      @upstream = upstream
      @latest = latest
    end
  end
end
