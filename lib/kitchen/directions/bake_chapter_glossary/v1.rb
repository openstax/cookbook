# frozen_string_literal: true

module Kitchen::Directions::BakeChapterGlossary
  class V1
    renderable

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

    def bake(chapter:, metadata_source:, append_to: nil, uuid_prefix: '')
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'glossary'
      @title = I18n.t(:eoc_key_terms_title)
      @uuid_prefix = uuid_prefix
      @glossary = []

      chapter.glossaries.search('dl').each do |definition_element|
        @glossary.push(Definition.new(definition_element.cut))
      end

      chapter.glossaries.trash

      @content = @glossary.sort.map { |definition| definition.element.paste }.join

      append_to_element = append_to || chapter
      @in_composite_chapter = append_to_element.is?(:composite_chapter)

      append_to_element.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
