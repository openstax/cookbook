module Kitchen
  class ChapterElementEnumerator < ElementEnumerator

    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "div[data-type='chapter']", # TODO element.document.selectors.chapter
        sub_element_class: ChapterElement,
        enumerator_class: self
      )
    end

  end
end
