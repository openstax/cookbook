# frozen_string_literal: true

module Kitchen
  # An enumerator for table elements
  #
  class TableElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: Selector.named(:table),
        sub_element_class: TableElement,
        enumerator_class: self
      )
    end

  end
end
