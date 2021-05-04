# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for further research
    #
    module BakeFurtherResearch
      def self.v1(chapter:, metadata_source:)
        metadata_elements = metadata_source.children_to_keep.copy

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

        chapter.append(child:
          <<~HTML
            <div class="os-eoc os-further-research-container" data-type="composite-page" data-uuid-key=".further-research">
              <h2 data-type="document-title">
                <span class="os-text">#{I18n.t(:eoc_further_research_title)}</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{I18n.t(:eoc_further_research_title)}</h1>
                #{metadata_elements.paste}
              </div>
              #{further_researches.paste}
            </div>
          HTML
        )
      end
    end
  end
end
