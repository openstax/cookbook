# frozen_string_literal: true

module Kitchen
  # An enumerator for composite page elements
  #
  class CompositePageElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: Selector.named(:composite_page),
        sub_element_class: CompositePageElement,
        enumerator_class: self
      )
    end

  end
end
