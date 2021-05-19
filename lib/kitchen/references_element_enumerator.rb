# frozen_string_literal: true

module Kitchen
  # An enumerator for table elements
  #
  class ReferenceElementEnumerator < ElementEnumeratorBase
    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: Selector.named(:reference),
        sub_element_class: ReferenceElement,
        enumerator_class: self
      )
    end

  end
end
