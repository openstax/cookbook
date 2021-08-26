# frozen_string_literal: true

module Kitchen
  # An enumerator for example elements
  #
  class InjectedQuestionElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: Selector.named(:injected_question),
        sub_element_class: InjectedQuestionElement,
        enumerator_class: self
      )
    end

  end
end
