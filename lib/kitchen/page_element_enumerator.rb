# frozen_string_literal: true

module Kitchen
  # An enumerator for page elements
  #
  class PageElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: Selector.named(:page),
        sub_element_class: PageElement,
        enumerator_class: self
      )
    end

  end
end
