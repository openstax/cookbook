# frozen_string_literal: true

module Kitchen
  module Directions
    # Bumps all headers to order after provided top header value
    module BakeOrderHeaders
      def self.v1(within:, top_header_value: 2)
        # grab & sort set of all headers
        header_set = [].to_set
        within.search('h1,h2,h3,h4,h5,h6').each { |header| header_set.add(header.name) }
        header_set = header_set.sort
        # map header_set to promoted headers, shifted by top_header_value
        header_map = {}
        header_set.each_with_index do |name, index|
          header_map[name] = "h#{index + top_header_value}"
        end
        # using the map, promote headers in place
        within.search('h1,h2,h3,h4,h5,h6').each do |header|
          header.name = header_map[header.name]
        end
      end
    end
  end
end
