# frozen_string_literal: true

module Kitchen::Directions::BakeFreeResponse
  class V1
    renderable

    def bake(chapter:, metadata_source:, append_to:)
      @metadata_elements = metadata_source.children_to_keep.copy

      @free_response_clipboard = Kitchen::Clipboard.new
      chapter.pages.each do |page|
        free_response_questions = page.free_response
        next if free_response_questions.none?

        free_response_questions.search('h3').trash
        title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: page)
        free_response_questions.each do |free_response_question|
          free_response_question.prepend(child: title)
          free_response_question.cut(to: @free_response_clipboard)
        end
      end

      return if @free_response_clipboard.none?

      append_to_element = append_to || chapter
      @title_tag = append_to ? 'h3' : 'h2'

      append_to_element.append(child: render(file: 'free_response.xhtml.erb'))
    end
  end
end
