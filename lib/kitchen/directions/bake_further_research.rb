# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for further research
    #
    module BakeFurtherResearch
      def self.v1(chapter:, metadata_source:, uuid_prefix: '.')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          uuid_prefix: uuid_prefix)
      end

      class V1
        renderable
        def bake(chapter:, metadata_source:, uuid_prefix: '.')
          MoveCustomSectionToEocContainer.v1(
            chapter: chapter,
            metadata_source: metadata_source,
            container_key: 'further-research',
            uuid_key: "#{uuid_prefix}further-research",
            section_selector: 'section.further-research',
            append_to: nil,
            include_intro_page: false
          ) do |further_research|
            RemoveSectionTitle.v1(section: further_research)
            title = EocSectionTitleLinkSnippet.v1(page: further_research.ancestor(:page))
            further_research.prepend(child: title)
            further_research.first('h3')[:itemprop] = 'name'
          end
        end
      end
    end
  end
end
