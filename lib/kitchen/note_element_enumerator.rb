module Kitchen
  class NoteElementEnumerator < ElementEnumeratorBase

    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "div[data-type='note']", # TODO get from config?
        sub_element_class: NoteElement,
        enumerator_class: self
      )
    end

  end
end
