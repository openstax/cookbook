# frozen_string_literal: true

module Kitchen::Directions::AnswerKeyCleaner
  def self.v1(book:, options: {})
    options.reverse_merge!(remove_empty_container: false)
    V1.new.bake(book: book, options: options)
  end

  class V1
    renderable

    def bake(book:, options:)
      answer_key_chapter_queries = %w[
        .os-eob.os-solutions-container[data-type="composite-chapter"]
        .os-eob.os-solution-container[data-type="composite-chapter"]
      ]
      chapters_query = answer_key_chapter_queries.join(', ')
      pages_query = answer_key_chapter_queries.map do |base_query|
        "#{base_query} > [data-type=\"composite-page\"]"
      end.join(', ')
      book.search(chapters_query).each do |chapter|
        chapter.search('$ > [data-type="composite-page"]').each do |page|
          page.trash unless page.contains?('[data-type="solution"]',
                                           '[data-type="question-solution"]')
        end
      end
      if options[:remove_empty_container]
        book.search(chapters_query).each do |chapter|
          chapter.trash unless chapter.search(
            '$ > [data-type="composite-page"]').to_a.length > 0
        end
      end
    end
  end
end
