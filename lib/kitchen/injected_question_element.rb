# frozen_string_literal: true

module Kitchen
  # An element for an example
  #
  class InjectedQuestionElement < ElementBase

    # Creates a new +InjectedQuestionElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: InjectedQuestionElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :injected_question
    end

    # Returns the question stimulus as an element.
    #
    # @return [Element]
    #
    def stimulus
      first('div[data-type="question-stimulus"]')
    end

    # Returns the question stem as an element.
    #
    # @return [Element]
    #
    def stem
      first('div[data-type="question-stem"]')
    end

    # Returns the list of answers as an element.
    #
    # @return [Element]
    #
    def answers
      first("ol[data-type='question-answers']")
    end

    # Returns the solution element.
    #
    # @return [Element]
    #
    def solution
      first("div[data-type='question-solution']")
    end

    # Returns the answer correctness given an alphabet
    #
    # @return [Array]
    #
    def correct_answer_letters(alphabet)
      answers.search('li[data-type="question-answer"]').each_with_index.map \
        do |answer, index|
        answer[:'data-correctness'] == '1.0' ? alphabet[index] : nil
      end.compact
    end

    # Returns or creates the question's id
    #
    # @return [String]
    #
    def id
      self[:id] ||= "auto_#{ancestor(:page).id.gsub(/page_/, '')}_#{self[:'data-id']}"
    end
  end
end
