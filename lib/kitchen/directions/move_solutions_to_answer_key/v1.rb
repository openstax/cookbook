# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  class V1
    # rubocop:disable Metrics/ParameterLists
    # This direction may need refactoring to simplify parameters
    def bake(chapter:, metadata_source:, strategy:, append_to:, strategy_options: {},
             solutions_plural: true)
      strategy =
        case strategy
        when :calculus
          Strategies::Calculus.new
        when :contemporary_math
          Strategies::ContemporaryMath.new
        when :uphysics
          Strategies::UPhysics.new
        when :precalculus
          Strategies::Precalculus.new
        when :default
          Strategies::Default.new(strategy_options)
        else
          raise 'No such strategy'
        end

      solutions_or_solution = solutions_plural ? 'solutions' : 'solution'
      append_to.append(child:
        <<~HTML
          <div class="os-eob os-#{solutions_or_solution}-container" data-type="composite-page" \
          data-uuid-key=".#{solutions_or_solution}#{chapter.count_in(:book)}">
            <h2 data-type="document-title">
              <span class="os-text">#{I18n.t(:chapter)} #{chapter.count_in(:book)}</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">#{I18n.t(:chapter)} #{chapter.count_in(:book)}</h1>
              #{metadata_source.children_to_keep.copy.paste}
            </div>
          </div>
        HTML
      )
      strategy.bake(chapter: chapter, append_to: append_to.last_element)
    end
    # rubocop:enable Metrics/ParameterLists
  end
end
