# frozen_string_literal: true

module Kitchen
  # An enumerator for metadata elements
  #
  class MetadataElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "div[data-type='metadata']",
        sub_element_class: MetadataElement,
        enumerator_class: self
      )
    end

  end
end
