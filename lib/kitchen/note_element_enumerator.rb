# frozen_string_literal: true
module Kitchen
  # An enumerator for note elements
  #
  class NoteElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "div[data-type='note']", # TODO: get from config?
        sub_element_class: NoteElement,
        enumerator_class: self
      )
    end

  end
end
