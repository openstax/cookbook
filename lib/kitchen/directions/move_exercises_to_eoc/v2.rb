# frozen_string_literal: true

module Kitchen::Directions::MoveExercisesToEOC
  # Main difference from v1 is the presence of a section title
  # and some additional wrappers
  class V2
    def bake(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
      exercise_clipboard = Kitchen::Clipboard.new

      chapter.non_introduction_pages.each do |page|
        sections = page.search("section.#{klass}")

        sections.each do |exercise_section|
          Kitchen::Directions::RemoveSectionTitle.v1(section: exercise_section)
          # Get parent page title
          section_title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: page)
          # Configure section title & wrappers
          exercise_section.prepend(child: section_title)
          exercise_section.wrap('<div class="os-section-area">')
          exercise_section = exercise_section.parent
          exercise_section.cut(to: exercise_clipboard)
        end
      end

      return if exercise_clipboard.none?

      content = <<~HTML
        <div class="os-#{klass}">
          #{exercise_clipboard.paste}
        </div>
      HTML

      Kitchen::Directions::EocCompositePageContainer.v1(
        container_key: klass,
        uuid_key: "#{uuid_prefix}#{klass}",
        metadata_source: metadata_source,
        content: content,
        append_to: append_to || chapter
      )
    end
  end
end
