module Kitchen
  class ChapterElementEnumerator < ElementEnumerator

    def self.within(element:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element: element,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "div[data-type='chapter']", # TODO element.document.selectors.chapter
                                      sub_element_class: ChapterElement)
    end

  end
end
