# frozen_string_literal: true

module Kitchen
  # An element for an example
  #
  class InjectedExerciseElement < ElementBase

    # Creates a new +InjectedQuestionElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: InjectedExerciseElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :injected_exercise
    end

    # Returns the exercise context element.
    # @return [Element]
    #
    def exercise_context
      first("div[data-type='exercise-context']")
    end

    # Returns the exercise question element.
    # @return [Element]
    #
    def exercise_question
      first("div[data-type='exercise-question']")
    end

  end
end
