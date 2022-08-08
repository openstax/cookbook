# frozen_string_literal: true

module Kitchen::Directions::AnswerKeyInnerContainer
  def self.v1(chapter:, metadata_source:, append_to:, options: {
    solutions_plural: true,
    in_appendix: false,
    cases: false
  })
    options.reverse_merge!(
      solutions_plural: true,
      in_appendix: false,
      cases: false
    )
    V1.new.bake(
      chapter: chapter,
      metadata_source: metadata_source,
      append_to: append_to,
      options: options
    )
  end

  class V1
    renderable

    def bake(chapter:, metadata_source:, append_to:, options:)
      @solutions_or_solution = options[:solutions_plural] ? 'solutions' : 'solution'
      @uuid_key = if options[:in_appendix]
                    "appendix#{@solutions_or_solution}#{chapter.count_in(:book)}"
                  else
                    @uuid_key = "#{@solutions_or_solution}#{chapter.count_in(:book)}"
                  end
      @metadata = metadata_source.children_to_keep.copy
      @composite_element = 'composite-page'
      @title = if options[:in_appendix]
                 "#{I18n.t("appendix#{'.nominative' if options[:cases]}")} #{[*('A'..'Z')][chapter.count_in(:book) - 1]}"
               else
                 "#{I18n.t("chapter#{'.nominative' if options[:cases]}")} #{chapter.count_in(:book)}"
               end
      @main_title_tag = 'h2'

      append_to.append(
        child: render(file: '../book_answer_key_container/eob_answer_key_container.xhtml.erb')
      ).first("div[data-uuid-key='.#{@uuid_key}']")
    end
  end
end
