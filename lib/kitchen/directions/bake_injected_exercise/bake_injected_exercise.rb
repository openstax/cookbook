# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExercise
  def self.v1(exercise:)
    V1.new.bake(exercise: exercise)
  end

  class V1
    def bake(exercise:)
      question_count = exercise.injected_questions.count
      exercise[:'data-question-count'] = question_count
      exercise[:'data-is-multipart'] = question_count > 1 ? 'True' : 'False'

      context = exercise&.exercise_context

      return unless context

      # link replacement is done by BakeLinkPlaceholders
      link = context.first('a').cut
      context.replace_children(with: "#{I18n.t(:context_lead_text)}#{link.paste}")
      return unless question_count == 1

      question = exercise.exercise_question
      question.prepend(child: context.cut.paste)
    end
  end
end
