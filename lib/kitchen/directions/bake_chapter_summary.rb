# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for eoc summary
    #
    module BakeChapterSummary
      def self.v1(chapter:, metadata_source:, uuid_prefix: '.')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          uuid_prefix: uuid_prefix
        )
      end

      class V1
        renderable
        def bake(chapter:, metadata_source:, uuid_prefix: '.')
          @metadata = metadata_source.children_to_keep.copy
          @klass = 'summary'
          @title = I18n.t(:eoc_summary_title)
          @uuid_prefix = uuid_prefix

          summaries = Clipboard.new

          # TODO: include specific page types somehow without writing it out
          chapter.non_introduction_pages.each do |page|
            summary = page.summary
            summary.first("[data-type='title']")&.trash # get rid of old title if exists
            summary_title = page.title.copy
            summary_title.name = 'h3'
            summary_title.replace_children(with: <<~HTML
              <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">#{summary_title.children}</span>
            HTML
            )

            summary.prepend(child:
              <<~HTML
                <a href="##{page.title.id}">
                  #{summary_title.paste}
                </a>
              HTML
            )
            summary.cut(to: summaries)
          end

          return if summaries.none?

          @content = summaries.paste
          @in_composite_chapter = false

          chapter.append(child: render(file:
            '../templates/eoc_section_title_template.xhtml.erb'))
        end
      end
    end
  end
end
