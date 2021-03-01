# frozen_string_literal: true
module Kitchen
  # An enumerator for chapter elements
  #
  class ChapterElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "div[data-type='chapter']", # TODO: element.document.selectors.chapter
        sub_element_class: ChapterElement,
        enumerator_class: self
      )
    end

  end
end
