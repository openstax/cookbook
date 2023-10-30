# frozen_string_literal: true

module Kitchen
  # An enumerator for image elements
  #
  class ImageElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: Selector.named(:image),
        sub_element_class: ImageElement,
        enumerator_class: self
      )
    end

  end
end
