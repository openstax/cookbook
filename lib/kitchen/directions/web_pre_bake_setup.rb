# frozen_string_literal: true

module Kitchen
  module Directions
    module WebPreBakeSetup
      def self.v1(book_pages:)
        puts 'Setting up baking for web ...' # since this is an invisible direction, logging shows that it's happening
        pantry = book_pages.first.ancestor(:book).pantry(name: :web_placeholders)

        # Replace title & metadata elements with placeholders
        book_pages.each do |page|
          { "title": page.title, "metadata": page.metadata }.each do |eltype, element|
            # safely store title/metadata element
            replacement_key = "#{page.id}-#{eltype}"
            pantry.store(element.copy, label: replacement_key)
            element[:'data-replacement-key'] = replacement_key

            # mangle element beyond recognition
            former_element = page.search("[data-replacement-key='#{replacement_key}']").first
            former_element.replace_children(with: "placeholder #{eltype}")
            former_element.remove_attribute('data-type')
            former_element.name = 'span'
          end
        end
      end
    end
  end
end
