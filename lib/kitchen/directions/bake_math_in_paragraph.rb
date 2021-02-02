module Kitchen
  module Directions
    module BakeMathInParagraph
      def self.v1(book:)
        book.search('//p//math | //p//m').each do |math|
          math.wrap("<span class='os-math-in-para'>")
        end
      end
    end
  end
end
