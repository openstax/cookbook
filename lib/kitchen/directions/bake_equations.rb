# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeEquations
      def self.v1(book:, number_decorator: :none)
        book.chapters.search('[data-type="equation"]:not(.unnumbered)').each do |eq|
          chapter = eq.ancestor(:chapter)
          number = "#{chapter.count_in(:book)}.#{eq.count_in(:chapter)}"

          # Store label information
          equation_label = "#{I18n.t(:equation)} #{number}"
          book.document.pantry(name: :link_text).store equation_label, label: eq.id

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
