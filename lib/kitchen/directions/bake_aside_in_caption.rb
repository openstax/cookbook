# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAsideInCaption
      def self.v1(caption_container:)
        caption_container.search('aside').each do |aside|
          caption_container.append(child: aside)
        end
      end
    end
  end
end
