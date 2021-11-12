# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExercise
  def self.v1(exercise:)
    V1.new.bake(exercise: exercise)
  end

  class V1
    def bake(exercise:)
      context = exercise&.exercise_context

      return unless context

      # link replacement is done by BakeLinkPlaceholders
      link = context.first('a').cut
      context.replace_children(with: "#{I18n.t(:context_lead_text)}#{link.paste}")
      questions_amount = exercise.injected_questions.count
      question = exercise.exercise_question
      return unless questions_amount == 1

      context_to_move = context.cut
      question.prepend(child: context_to_move.paste)
    end
  end
end
