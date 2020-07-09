module Kitchen
  class CompositePageElementEnumerator < ElementEnumeratorBase

    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "div[data-type='composite-page']",
        sub_element_class: CompositePageElement,
        enumerator_class: self
      )
    end

  end
end
