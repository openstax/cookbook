module Kitchen
  class ElementFactory

    ELEMENT_CLASSES = ElementBase.descendants

    def self.specific_element_class_for_node(node)
      ELEMENT_CLASSES.find do |klass|
        klass.is_the_element_class_for?(node)
      end || Element
    end

    def self.build_from_node(node:,
                             document:,
                             element_class: nil,
                             default_short_type: nil,
                             detect_element_class: false)
      element_class ||= detect_element_class ?
                        specific_element_class_for_node(node) :
                        Element

      if element_class == Element
        element_class.new(node: node,
                              document: document,
                              short_type: default_short_type)
      else
        element_class.new(node: node,
                              document: document)
      end
    end

  end
end
