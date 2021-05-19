# frozen_string_literal: true

module Kitchen
  # An enumerator for unit elements
  #
  class UnitElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: Selector.named(:unit),
        sub_element_class: UnitElement,
        enumerator_class: self
      )
    end
  end
end
