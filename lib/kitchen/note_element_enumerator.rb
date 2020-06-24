module Kitchen
  class NoteElementEnumerator < ElementEnumerator

    def self.within(element:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element: element,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "div[data-type='note']", # TODO element.document.selectors.note
                                      sub_element_class: NoteElement)
    end

  end
end
