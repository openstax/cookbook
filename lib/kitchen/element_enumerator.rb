# frozen_string_literal: true

module Kitchen
  # An enumerator for any old non-specific element
  #
  class ElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        sub_element_class: Element,
        enumerator_class: self
      )
    end

  end
end
