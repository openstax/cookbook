# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for further research
    #
    module BakeFurtherResearch
      def self.v1(chapter:, metadata_source:, append_to: nil, uuid_prefix: '.')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          uuid_prefix: uuid_prefix)
      end

      class V1
        renderable
        def bake(chapter:, metadata_source:, append_to:, uuid_prefix:)
          @metadata = metadata_source.children_to_keep.copy
          @klass = 'further-research'
          @title = I18n.t(:eoc_further_research_title)
          @uuid_prefix = uuid_prefix

          further_researches = Clipboard.new

          chapter.non_introduction_pages.each do |page|
            further_research = page.first('.further-research')
            further_research.first("[data-type='title']")&.trash # get rid of old title if exists
            further_research_title = page.title.copy
            further_research_title.name = 'h3'
            further_research_title.replace_children(with: <<~HTML
              <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">#{further_research_title.children}</span>
            HTML
            )

            further_research.prepend(child:
              <<~HTML
                <a href="##{page.title.id}">
                  #{further_research_title.paste}
                </a>
              HTML
            )
            further_research.cut(to: further_researches)
          end

          return if further_researches.none?

          @content = further_researches.paste

          append_to_element = append_to || chapter
          @in_composite_chapter = append_to_element.is?(:composite_chapter)

          append_to_element.append(child: render(file:
            '../templates/eoc_section_title_template.xhtml.erb'))
        end
      end
    end
  end
end
