module Kitchen
  class PageElementEnumerator < ElementEnumerator

    def self.within(element:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element: element,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "div[data-type='page']", # TODO element.document.selectors.page
                                      sub_element_class: PageElement)
    end

  end
end
