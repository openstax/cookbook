module Kitchen
  module Directions
    module BakeChapterExercises

      def self.v1(chapter:, metadata_source:)
        # TODO put the _copy_1 suffix on ID logic into `copy` as an option?
        # have document keep a list of IDs and how many copies have been made
        metadata_elements = metadata_source.elements(%w(.authors .publishers .print-style
                                                        .permissions [data-type='subject'])).copy

        exercises = Clipboard.new
        chapter.pages.each do |page|
          next if page.is_introduction?

          exercise_section = page.exercises
          exercise_section.first("h3").trash # get rid of old title
          exercise_section_title = page.title.clone
          exercise_section_title.name = "h3"
          exercise_section.prepend(child:
            <<~HTML
              <a href="##{page.title.id}">
                #{exercise_section_title}
              </a>
            HTML
          )
          exercise_section.cut(to: exercises)
        end

        chapter.append(child:
          <<~HTML
            <div class="os-eoc os-exercises-container" data-type="composite-page" data-uuid-key=".exercises">
              <h2 data-type="document-title">
                <span class="os-text">#{I18n.t(:exercises)}</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{I18n.t(:exercises)}</h1>
                #{metadata_elements.paste}
              </div>
              #{exercises.paste}
            </div>
          HTML
        )
      end

    end
  end
end
