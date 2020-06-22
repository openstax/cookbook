module Kitchen
  class TermElementEnumerator < ElementEnumerator

    def self.within(element_or_document:, css_or_xpath: nil)
      css_or_xpath ||= "$"
      css_or_xpath.gsub!(/\$/, "span[data-type='term']") # TODO element.document.selectors.term

      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element_or_document: element_or_document,
                                      css_or_xpath: css_or_xpath,
                                      sub_element_class: TermElement)
    end

    def self.chained_to_enumerator(other_enumerator)
      ElementEnumeratorFactory.chained_to_other(new_enumerator_class: self,
                                                other_enumerator: other_enumerator)
    end

  end
end
