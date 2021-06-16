# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V2
    renderable

    def bake(book:, metadata_source:)
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'references'
      @uuid_prefix = '.'
      @title = I18n.t(:references)

      book.chapters.each do |chapter|

        chapter.references.search('h3').trash

        chapter_references = chapter.pages.references.cut
        chapter_title_no_num = chapter.title.search('.os-text')

        chapter.append(child:
          <<~HTML
            <div class="os-chapter-area">
              <h2 data-type="document-title">#{chapter_title_no_num}</h2>
              #{chapter_references.paste}
            </div>
          HTML
        )
      end
      chapter_area_references = book.chapters.search('.os-chapter-area').cut
      @content = chapter_area_references.paste
      book.body.append(child: render(file:
        '../../templates/eob_section_title_template.xhtml.erb'))
    end
  end
end
