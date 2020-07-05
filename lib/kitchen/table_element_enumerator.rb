module Kitchen
  class TableElementEnumerator < ElementEnumerator

    def self.factory
      ElementEnumeratorFactory.new(
        default_css_or_xpath: "table", # TODO get from config?
        sub_element_class: TableElement,
        enumerator_class: self
      )
    end

  end
end
