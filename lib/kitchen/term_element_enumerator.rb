# frozen_string_literal: true
module Kitchen
  # An enumerator for term elements
  #
  class TermElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "span[data-type='term']", # TODO: get from config?
        sub_element_class: TermElement,
        enumerator_class: self
      )
    end

  end
end
