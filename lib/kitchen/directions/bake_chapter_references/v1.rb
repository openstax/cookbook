# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V1
    renderable

    def bake(chapter:, metadata_source:, uuid_prefix: '.', klass: 'references')
      @metadata = metadata_source.children_to_keep.copy
      @klass = klass
      @title = I18n.t(:references)
      @uuid_prefix = uuid_prefix

      chapter.references.search('h3').trash

      bake_page_references(page: chapter.introduction_page)

      chapter.non_introduction_pages.each do |page|
        bake_page_references(page: page)
      end

      @content = chapter.pages.references.cut.paste
      chapter.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end

    def bake_page_references(page:)
      return if page.nil?

      references = page.references
      return if references.none?

      title = if page.is_introduction?
                <<~HTML
                  <a href="##{page.title.id}">
                    <h3 data-type="document-title" id="#{page.title.copied_id}">
                      <span class="os-text" data-type="" itemprop="">#{page.title_text}</span>
                    </h3>
                  </a>
                HTML
              else
                Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: page)
              end

      references.each do |reference|
        reference.prepend(child: title)
      end
    end
  end
end
