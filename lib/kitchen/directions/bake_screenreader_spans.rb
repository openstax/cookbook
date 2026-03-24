# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeScreenreaderSpans
      # Add text for accessibility.
      # Additional screenreader spans can be added below.
      def self.v1(book:)
        underline = I18n.t(:'screenreader.underline')
        double_underline = I18n.t(:'screenreader.double-underline')
        public_domain = I18n.t(:'screenreader.public-domain')
        student_sample = I18n.t(:'screenreader.student-sample')
        annotation_text = I18n.t(:'screenreader.annotation-text')
        end_string = I18n.t(:'screenreader.end')

        book.search('u[data-effect="underline"]').each do |element|
          begin_message = underline
          end_message = "#{end_string} #{underline}"
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
        book.search('u[data-effect="double-underline"]').each do |element|
          begin_message = double_underline
          end_message = "#{end_string} #{double_underline}"
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
        book.search('p.public-domain').each do |element|
          begin_message = public_domain
          end_message = "#{end_string} #{public_domain}"
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
        book.search('p.student-sample').each do |element|
          begin_message = student_sample
          end_message = "#{end_string} #{student_sample}"
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
        book.search('p.annotation-text').each do |element|
          begin_message = annotation_text
          end_message = "#{end_string} #{annotation_text}"
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
      end

      def self.add_screenreader_text(element:, begin_message:, end_message:)
        element[:'data-screenreader-begin'] = begin_message
        element[:'data-screenreader-end'] = end_message
        element.prepend(child:
          "<span data-media=\"screenreader\">#{begin_message}</span>"
        )
        element.append(child:
          "<span data-media=\"screenreader\">#{end_message}</span>"
        )
      end
    end
  end
end
