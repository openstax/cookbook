# frozen_string_literal: true

module Kitchen::Directions::EocCompositePageContainer
  class V1
    renderable

    def bake(container_key:, uuid_key:, metadata_source:, content:, append_to:)
      @title = I18n.t(:"eoc.#{container_key}")
      @uuid_key = uuid_key
      @container_class_type = container_key
      @metadata = metadata_source.children_to_keep.copy
      @content = content
      @in_composite_chapter = append_to.is?(:composite_chapter)

      append_to.append(child: render(file:
        '../../templates/eoc_section_template.xhtml.erb'))
    end
  end
end
