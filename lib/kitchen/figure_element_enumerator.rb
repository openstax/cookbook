# frozen_string_literal: true

module Kitchen
  # An enumerator for figure elements
  #
  class FigureElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: 'figure', # TODO: get from config?
        sub_element_class: FigureElement,
        enumerator_class: self
      )
    end

  end
end
