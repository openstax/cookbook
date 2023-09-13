# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeImages
      def self.v1(book:, resources:)
        # Add image dimensions to <img>s
        book.images.each do |image|
          img_src = image.resource_key
          img_json = resources&.[](img_src)
          if img_json
            scale = \
              if image[:width]
                image[:width].to_f / img_json[:width].to_i
              elsif image[:height]
                image[:height].to_f / img_json[:height].to_i
              else
                1
              end
            image[:'data-width'] = (img_json[:width].to_i * scale).floor
            image[:'data-height'] = (img_json[:height].to_i * scale).floor
          else
            warn("Could not find resource for image with src #{image.src}")
          end
        end
      end
    end
  end
end
