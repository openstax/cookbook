# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeEquations
      def self.v1(book:, number_decorator: :none, cases: false)
        book.chapters.search('div[data-type="equation"]:not(.unnumbered)').each do |eq|
          chapter = eq.ancestor(:chapter)
          number = "#{chapter.count_in(:book)}.#{eq.count_in(:chapter)}"

          # Store label information
          eq.target_label(label_text: 'equation', custom_content: number, cases: cases)

          decorated_number =
            case number_decorator
            when :none
              number
            when :parentheses
              "(#{number})"
            else
              raise "Unsupported number_decorator '#{number_decorator}'"
            end

          # Bake the equation
          eq.append(child:
            <<~HTML
              <div class="os-equation-number">
                <span class="os-number">#{decorated_number}</span>
              </div>
            HTML
          )
        end
      end
    end
  end
end
