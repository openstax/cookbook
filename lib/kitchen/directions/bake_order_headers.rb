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
          if header_map[header.name] == 'h2' && header['data-type'] == 'document-title'
            header['data-rex-keep'] = true
            # play nice with https://github.com/openstax/rex-web/blob/main/src/app/content/components/Page/contentDOMTransformations.ts#L39
          end
          header.name = header_map[header.name]
        end
      end

      def self.v2(within:, top_header_value: 1)
        last = -1
        within.search('h1,h2,h3,h4,h5,h6').each do |header|
          depth = header.name[-1].to_i
          if last == -1
            depth = top_header_value
          elsif depth > last + 1
            depth = last + 1
          end
          name = "h#{depth}"
          header.name = name
          # https://github.com/openstax/rex-web/blob/a3dd80667d6503d6b2eeea0d58c1b775c85b9500/src/app/content/components/Page/contentDOMTransformations.ts#L40
          header['data-rex-keep'] = true if name == 'h2' && header['data-type'] == 'document-title'
          last = depth
        end
      end
    end
  end
end
