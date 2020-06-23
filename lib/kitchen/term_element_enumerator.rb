module Kitchen
  class TermElementEnumerator < ElementEnumerator

    def self.within(element_or_document:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element_or_document: element_or_document,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "span[data-type='term']", # TODO element.document.selectors.term
                                      sub_element_class: TermElement)
    end

    # def self.chained_to_enumerator(other_enumerator)
    #   ElementEnumeratorFactory.chained_to_other(new_enumerator_class: self,
    #                                             other_enumerator: other_enumerator)
    # end

  end
end
