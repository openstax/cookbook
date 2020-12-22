module Kitchen
  module Directions
    module BakeMathInParagraph
      def self.v1(book:)
        book.search('p m|math').each do |math|
          math.wrap("<span class='os-math-in-para'>")
        end
      end
    end
  end
end
