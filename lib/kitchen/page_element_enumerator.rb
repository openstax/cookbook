module Kitchen
  class PageElementEnumerator < ElementEnumerator

    def terms(css_or_xpath=nil, &block)
      chain_to(enumerator_class: TermElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def self.within(element_or_document:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element_or_document: element_or_document,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "div[data-type='page']", # TODO element.document.selectors.page
                                      sub_element_class: PageElement)
    end

    def self.chained_to_enumerator(other_enumerator, css_or_xpath: nil)
      ElementEnumeratorFactory.chained_to_other(new_enumerator_class: self,
                                                other_enumerator: other_enumerator,
                                                css_or_xpath: css_or_xpath)
    end

  end
end
