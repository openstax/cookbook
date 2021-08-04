# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for eoc summary
    #
    module BakeChapterSummary
      def self.v1(chapter:, metadata_source:, klass: 'summary', uuid_prefix: '.')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          uuid_prefix: uuid_prefix,
          klass: klass
        )
      end

      class V1
        def bake(chapter:, metadata_source:, uuid_prefix: '.', klass: 'summary')
          summaries = Clipboard.new

          chapter.pages.each do |page|
            summary = page.summary

            next if summary.nil?

            summary.first("[data-type='title']")&.trash # get rid of old title if exists
            title = EocSectionTitleLinkSnippet.v1(page: page)
            summary.prepend(child: title)
            summary.cut(to: summaries)
          end

          return if summaries.none?

          EocCompositePageContainer.v1(
            container_key: klass,
            uuid_key: "#{uuid_prefix}#{klass}",
            metadata_source: metadata_source,
            content: summaries.paste,
            append_to: chapter
          )
        end
      end
    end
  end
end
