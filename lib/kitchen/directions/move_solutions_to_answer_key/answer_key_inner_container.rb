# frozen_string_literal: true

module Kitchen::Directions::AnswerKeyInnerContainer
  def self.v1(chapter:, metadata_source:, append_to:, solutions_plural: true, in_appendix: false, cases: false)
    V1.new.bake(
      chapter: chapter,
      metadata_source: metadata_source,
      append_to: append_to,
      solutions_plural: solutions_plural,
      in_appendix: in_appendix,
      cases: cases
    )
  end

  class V1
    renderable

    def bake(chapter:, metadata_source:, append_to:, solutions_plural:, in_appendix:, cases:)
      @solutions_or_solution = solutions_plural ? 'solutions' : 'solution'
      @uuid_key = if in_appendix
                    "appendix#{@solutions_or_solution}#{chapter.count_in(:book)}"
                  else
                    @uuid_key = "#{@solutions_or_solution}#{chapter.count_in(:book)}"
                  end
      @metadata = metadata_source.children_to_keep.copy
      @composite_element = 'composite-page'
      @title = if in_appendix
                 "#{I18n.t("appendix#{'.nominative' if cases}")} #{[*('A'..'Z')][chapter.count_in(:book) - 1]}"
               else
                 "#{I18n.t("chapter#{'.nominative' if cases}")} #{chapter.count_in(:book)}"
               end
      @main_title_tag = 'h2'

      append_to.append(
        child: render(file: '../book_answer_key_container/eob_answer_key_container.xhtml.erb')
      ).first("div[data-uuid-key='.#{@uuid_key}']")
    end
  end
end
