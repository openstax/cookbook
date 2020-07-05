module Kitchen
  class PageElementEnumerator < ElementEnumeratorBase

    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "div[data-type='page']", # TODO get from config?
        sub_element_class: PageElement,
        enumerator_class: self
      )
    end

  end
end
