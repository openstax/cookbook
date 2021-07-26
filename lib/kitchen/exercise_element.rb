# frozen_string_literal: true

module Kitchen
  # An element for an example
  #
  class ExerciseElement < ElementBase

    # Creates a new +ExerciseElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: ExerciseElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :exercise
    end

    # Returns the enumerator for problem.
    #
    # @return ElementEnumerator
    #
    def problem
      first("div[data-type='problem']")
    end

    # Returns the enumerator for solution.
    #
    # @return ElementEnumerator
    #
    def solution
      first("div[data-type='solution']")
    end

    # Returns whether the exercise has been baked
    #
    # @return [Boolean]
    #
    def baked?
      search('div.os-problem-container').any?
    end
  end
end
