# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class BakeChapterObjectives
    def bake(chapter:, strategy:, options:)
      case strategy
      when :default
        bake_as_note(chapter: chapter)
      when :add_objectives
        add_chapter_objectives(chapter: chapter, options: options)
      when :none
        ''
      else
        raise 'No such strategy'
      end
    end

    def bake_as_note(chapter:)
      chapter_objectives_note = chapter.notes('$.chapter-objectives').first

      return unless chapter_objectives_note.present?

      # trash existing title
      chapter_objectives_note.titles.first&.trash
      Kitchen::Directions::BakeAutotitledNotes.v1(
        book: chapter,
        classes: %w[chapter-objectives],
        options: { bake_subtitle: false }
      )

      chapter_objectives_note.cut.paste
    end

    def add_chapter_objectives(chapter:, options: {})
      options.reverse_merge!(numbering_options: { mode: :chapter_page, separator: '.' })
      chapter.non_introduction_pages.map do |page|
        number = page.os_number(options[:numbering_options])
        <<~HTML
          <div class="os-chapter-objective">
            <a class="os-chapter-objective" href="##{page.id}">
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
              <span data-type="" itemprop="" class="os-text">#{page.title_children}</span>
            </a>
          </div>
        HTML
      end.join('')
    end
  end
end
