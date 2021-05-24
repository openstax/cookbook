# frozen_string_literal: true

module Kitchen::Directions::BookAnswerKeyContainer
  class V1
    renderable

    def bake(book:)
      @metadata = book.metadata.children_to_keep.copy
      book.body.append(child: render(file: 'eob_solutions_container.xhtml.erb'))
      book.body.first('div.os-eob.os-solutions-container')
    end
  end
end
