module Kitchen
  class FigureElementEnumerator < ElementEnumerator

    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "figure", # TODO get from config?
        sub_element_class: FigureElement,
        enumerator_class: self
      )
    end

  end
end
