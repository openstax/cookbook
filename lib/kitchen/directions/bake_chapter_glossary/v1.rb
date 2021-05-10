# frozen_string_literal: true

module Kitchen::Directions::BakeChapterGlossary
  class V1
    renderable

    def bake(chapter:, metadata_source:, append_to: nil, uuid_prefix: '')
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'glossary'
      @title = I18n.t(:eoc_key_terms_title)
      @uuid_prefix = uuid_prefix

      definitions = chapter.glossaries.search('dl').cut
      return if definitions.none?
      definitions.sort_by! do |definition|
        [definition.first('dt').text.downcase, definition.first('dd').text.downcase]
      end

      chapter.glossaries.trash

      @content = definitions.paste

      append_to_element = append_to || chapter
      @in_composite_chapter = append_to_element[:'data-type'] == 'composite-chapter'

      append_to_element.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
