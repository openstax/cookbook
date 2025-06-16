# frozen_string_literal: true

module Kitchen::Directions::BakeChapterSectionExercises
  class V1
    def bake(chapter:, options:)
      chapter.non_introduction_pages.each do |page|
        page.search('section.section-exercises').each do |section|
          section.first('h3[data-type="title"]')&.trash if options[:trash_title]
          section.wrap(
            %(<div class="os-eos os-section-exercises-container"
              data-uuid-key=".section-exercises">)
          )

          next unless options[:create_title]

          section_title = I18n.t(
            :section_exercises,
            number: page.os_number(options[:numbering_options]))

          section.prepend(sibling:
            <<~HTML
              <h3 data-type="document-title">
                <span class="os-text">#{section_title}</span>
              </h3>
            HTML
          )
        end
      end
    end
  end
end
