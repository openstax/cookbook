module Kitchen
  class TableElementEnumerator < ElementEnumerator

    def self.within(element:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element: element,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "table", # TODO element.document.selectors.table
                                      sub_element_class: TableElement)
    end

  end
end
