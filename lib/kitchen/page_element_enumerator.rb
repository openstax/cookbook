module Kitchen
  class PageElementEnumerator < ElementEnumerator

    def self.within(element_or_document:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element_or_document: element_or_document,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "div[data-type='page']", # TODO element.document.selectors.page
                                      sub_element_class: PageElement)
    end

  end
end
