module Kitchen
  class TermElementEnumerator < ElementEnumerator

    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "span[data-type='term']", # TODO get from config?
        sub_element_class: TermElement,
        enumerator_class: self
      )
    end

  end
end
