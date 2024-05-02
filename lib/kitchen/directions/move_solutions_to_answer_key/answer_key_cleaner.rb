# frozen_string_literal: true

module Kitchen::Directions::AnswerKeyCleaner
  def self.v1(book:)
    V1.new.bake(book: book)
  end

  class V1
    renderable

    def bake(book:)
      answer_key_chapters = book.search(
        '.os-eob[data-type="composite-chapter"] > [data-type="composite-page"]')
      answer_key_chapters.each do |container|
        if !(container.contains?('[data-type="solution"]') || container.contains?('[data-type="question-solution"]'))
        container.trash
        end
      end
    end
  end
end
