# frozen_string_literal: true

module Kitchen
  # An enumerator for example elements
  #
  class InjectedExerciseElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: Selector.named(:injected_exercise),
        sub_element_class: InjectedExerciseElement,
        enumerator_class: self
      )
    end

  end
end
