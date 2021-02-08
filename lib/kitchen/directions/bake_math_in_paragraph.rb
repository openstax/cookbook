# frozen-string-literal: true

module Kitchen
  module Directions
    # Wraps any math contained in a <p> tag
    # with a <span> with class 'os-math-in-para'
    module BakeMathInParagraph
      def self.v1(book:)
        book.search('p m|math', '//p//math | //p//m').each do |math|
          math.wrap("<span class='os-math-in-para'>")
        end
      end
    end
  end
end
