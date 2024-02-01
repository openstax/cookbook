# frozen_string_literal: true

module Kitchen::Directions::BakeSortableSection
  class V1
    class SortableElement
      attr_reader :element

      def initialize(element)
        sortable_element = Kitchen::I18nString.new(element.text.downcase)
        @sortable = [sortable_element]
        @element = element
      end

      def <=>(other)
        sortable <=> other.sortable
      end

      protected

      attr_reader :sortable
    end

    def bake(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
      @paragraphs = []

      chapter.search("section.#{klass}").search('p').each do |para|
        @paragraphs.push(SortableElement.new(para.cut))
      end

      chapter.search("section.#{klass}").trash

      content = @paragraphs.sort.map { |paragraph| paragraph.element.paste }.join

      return if content.empty?

      Kitchen::Directions::CompositePageContainer.v1(
        container_key: klass.to_s,
        uuid_key: "#{uuid_prefix}#{klass}",
        metadata_source: metadata_source,
        content: content,
        append_to: append_to || chapter
      )
    end
  end
end
