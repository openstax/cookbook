# frozen_string_literal: true

module Kitchen::Directions::BookAnswerKeyContainer
  class V1
    renderable

    def bake(book:, solutions_plural:)
      @composite_element = 'composite-chapter'
      @metadata = book.metadata.children_to_keep.copy
      @solutions_or_solution = solutions_plural ? 'solutions' : 'solution'
      @title = I18n.t(:answer_key_title)
      @main_title_tag = 'h1'
      @uuid_key = @solutions_or_solution
      book.body.append(child: render(file: 'eob_answer_key_container.xhtml.erb'))
      book.body.first("div.os-eob.os-#{@solutions_or_solution}-container")
    end
  end
end
