# frozen_string_literal: true

module Kitchen::Directions::BakeChapterGlossary
  class V1
    class Definition
      attr_reader :element

      def initialize(element)
        term = Kitchen::I18nString.new(element.first('dt').text.downcase)
        description = Kitchen::I18nString.new(element.first('dd').text.downcase)
        @sortable = [term, description]
        @element = element
      end

      def <=>(other)
        sortable <=> other.sortable
      end

      protected

      attr_reader :sortable
    end

    def bake(chapter:, metadata_source:, append_to: nil, uuid_prefix: '', has_para: false)
      @glossary = []

      # Use for books created by Adaptarr, where dd contains paragraphs
      # More info: https://github.com/openstax/kitchen/issues/284
      if has_para
        chapter.glossaries.search('dd').each do |description|
          description_content = description.first('p').text
          description.replace_children with: description_content
        end
      end

      chapter.glossaries.search('dl').each do |definition_element|
        @glossary.push(Definition.new(definition_element.cut))
      end

      chapter.glossaries.trash

      content = @glossary.sort.map { |definition| definition.element.paste }.join

      Kitchen::Directions::CompositePageContainer.v1(
        container_key: 'glossary',
        uuid_key: "#{uuid_prefix}glossary",
        metadata_source: metadata_source,
        content: content,
        append_to: append_to || chapter
      )
    end
  end
end
