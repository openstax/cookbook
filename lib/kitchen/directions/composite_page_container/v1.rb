# frozen_string_literal: true

module Kitchen::Directions::CompositePageContainer
  class V1
    renderable

    def bake(container_key:, uuid_key:, metadata_source:, content:, append_to:)
      @in_composite_chapter = append_to.is?(:composite_chapter)
      @is_eoc = append_to.is?(:chapter) || @in_composite_chapter
      @section = @is_eoc ? 'eoc' : 'eob'
      @title = I18n.t(:"#{@section}.#{container_key}")
      @uuid_key = uuid_key
      @container_class_type = container_key
      @metadata = metadata_source.children_to_keep.copy
      @content = content
      @main_title_tag = 'h1'

      if @in_composite_chapter
        @main_title_tag = 'h3'
      elsif @is_eoc
        @main_title_tag = 'h2'
      end

      append_to.append(child: render(file:
        '../../templates/composite_page_template.xhtml.erb'))
    end
  end
end
