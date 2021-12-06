# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V3
    class Reference
      attr_reader :element

      def initialize(element)
        reference_item = Kitchen::I18nString.new(element.text.downcase)
        @sortable = [reference_item]
        @element = element
      end

      def <=>(other)
        sortable <=> other.sortable
      end

      protected

      attr_reader :sortable
    end

    def bake(chapter:, metadata_source:, append_to: nil, uuid_prefix: '.')
      @references = []

      chapter.references.search('p').each do |reference_element|
        @references.push(Reference.new(reference_element.cut))
      end

      chapter.references.trash

      content = @references.sort.map { |reference| reference.element.paste }.join

      return if content.empty?

      Kitchen::Directions::CompositePageContainer.v1(
        container_key: 'references',
        uuid_key: "#{uuid_prefix}references",
        metadata_source: metadata_source,
        content: content,
        append_to: append_to || chapter
      )
    end
  end
end
