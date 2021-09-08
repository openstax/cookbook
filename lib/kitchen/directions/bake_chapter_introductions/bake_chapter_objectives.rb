# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class BakeChapterObjectives
    def bake(chapter:, strategy:)
      case strategy
      when :default
        bake_as_note(chapter: chapter)
      when :add_objectives
        add_chapter_objectives(chapter: chapter)
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
        bake_subtitle: false
      )

      chapter_objectives_note.cut.paste
    end

    def add_chapter_objectives(chapter:)
      chapter.non_introduction_pages.map do |page|
        <<~HTML
          <div class="os-chapter-objective">
            <a class="os-chapter-objective" href="##{page.title[:id]}">
              <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
              <span class="os-divider"> </span>
              <span data-type="" itemprop="" class="os-text">#{page.title.children[0].text}</span>
            </a>
          </div>
        HTML
      end.join('')
    end
  end
end
