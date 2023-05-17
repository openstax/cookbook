# frozen_string_literal: true

require 'byebug'

module Kitchen
  module Directions
    module BakeImages
      def self.v1(book:, resources:)
        # Add image dimensions to <img>s
        book.search('img').each do |image|
          img_src = image[:src].gsub('../resources/', '').gsub('.json', '')
          img_json = resources&.[](img_src)
          if img_json
            image[:width] = img_json['width']
            image[:height] = img_json['height']
          else
            warn("Could not find resource for image with id: #{image.id}")
          end
        end
      end
    end
  end
end
