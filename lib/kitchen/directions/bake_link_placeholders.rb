# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for link placeholders
    #
    module BakeLinkPlaceholders
      def self.v1(book:, cases: false, replace_section_link_text: false)
        # passing in relevant ids to overwrite
        ids_to_link_overwrite = replace_section_link_text ? book.chapters.pages.map(&:id) : []

        book.search('a').each do |anchor|
          next unless anchor.text == '[link]'

          if anchor[:href].nil? || anchor[:href][1..].blank?
            warn "warning! Link has no href on element: '#{anchor}'"
            next
          end

          label_case = anchor['cmlnle:case'] || anchor['case']
          id = anchor[:href][1..]

          if cases
            pantry_name = if anchor.key?('case')
                            "#{label_case}_link_text"
                          else
                            'nominative_link_text'
                          end

            replacement = book.pantry(name: pantry_name).get(id)
          else
            replacement = book.pantry(name: :link_text).get(id)
          end

          if replacement.present?
            if ids_to_link_overwrite.detect { |i| i.match(id) }
              # matches section number up to 99.99
              os_number = replacement.match(/([1-9][0-9]|[0-9]).([0-9][0-9]|[0-9])/)

              replacement = "#{I18n.t(:section)} #{os_number}"
            end

            anchor.replace_children(with: replacement)
          else
            # TODO: log a warning!
            warn "warning! could not find a replacement for '[link]' on an element with ID '#{id}'"
          end

          link_class = book.pantry(name: :link_type).get(id)
          anchor.add_class(link_class) if link_class.present?
        end
      end
    end
  end
end
