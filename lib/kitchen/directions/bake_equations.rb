# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeEquations
      def self.v1(book:, number_decorator: :none, cases: false)
        _v1_bake_in_chapters(
          chapters: book.chapters,
          number_decorator: number_decorator,
          cases: cases,
          numbering_options: { mode: :chapter_page, separator: '.' })
      end

      def self.v2(chapters:, number_decorator: :none, cases: false, numbering_options: {})
        _v1_bake_in_chapters(
          chapters: chapters,
          number_decorator: number_decorator,
          cases: cases,
          numbering_options: numbering_options)
      end

      def self._v1_bake_in_chapters(chapters:, number_decorator:, cases:, numbering_options:)
        chapters.search('div[data-type="equation"]:not(.unnumbered)').each do |eq|
          number = eq.os_number(numbering_options)

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

      class << self
        private :_v1_bake_in_chapters
      end
    end
  end
end
