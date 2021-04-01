# frozen_string_literal: true

module Kitchen::Directions::BakeChapterSectionExercises
  class V1
    def bake(chapter:)
      chapter.pages.each do |page|
        page.search('section.section-exercises').each do |section|
          section.wrap(
            %(<div class="os-eos os-section-exercises-container"
              data-uuid-key=".section-exercises">)
          )

          section_title = I18n.t(
            :section_exercises,
            number: "#{chapter.count_in(:book)}.#{section.count_in(:chapter)}")

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
