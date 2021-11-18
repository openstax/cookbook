# frozen_string_literal: true

# Make debug output more useful (dumping entire document out is not useful)
module Nokogiri
  module XML
    # Monkey patches for Nokogiri::XML::Document
    # @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Document Nokogiri::XML::Document
    class Document
      # Hides the guts of the document when printed out so you don't get 5MB dumped into your
      # terminal
      #
      def inspect
        'Nokogiri::XML::Document <hidden for brevity>'
      end

      # Alphabetizes all attributes within the document, useful for comparing one
      # document to another (since attribute order isn't meaningful)
      #
      def alphabetize_attributes!
        traverse do |child|
          next if child.text? || child.document?

          child_attributes = child.attributes
          child_attributes.each do |key, _value|
            child.remove_attribute(key)
          end
          sorted_keys = child_attributes.keys.sort
          sorted_keys.each do |key|
            value = child_attributes[key].to_s
            child[key] = value
          end
        end
      end

      def add_all_namespaces!
        # Nokogiri by default only recognizes the namespaces on the root node.  Collect all
        # namespaces and add them manually.
        return if @all_namespaces_added

        collect_namespaces.each do |namespace, url|
          prefix, name = namespace.split(':')
          next unless prefix == 'xmlns' && name.present?

          root.add_namespace_definition(name, url)
        end

        @all_namespaces_added = true
      end
    end

    # Monkey patches for Nokogiri::XML::Node
    # @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node Nokogiri::XML::Node
    class Node
      # Calls to_s on the node
      #
      # @return [String]
      #
      def inspect
        to_s
      end

      def quick_matches?(selector)
        self.class.selector_to_css_nodes(selector).any? { |css_node| matches_css_node?(css_node) }
      end

      def classes
        self[:class]&.split || []
      end

      def previous
        prev = previous_element
        return nil if prev.nil?

        prev.text? ? prev.previous : prev
      end

      def preceded_by_text?
        prev = previous_sibling
        while !prev.nil? && prev.blank? do prev = prev.previous_sibling end
        return false if prev.nil?

        prev.text?
      end

      def self.selector_to_css_nodes(selector)
        # No need to parse the same selector more than once.
        @parsed_selectors ||= {}
        @parsed_selectors[selector] ||= Nokogiri::CSS::Parser.new.parse(selector)
      end

      protected

      # rubocop:disable Metrics/CyclomaticComplexity
      def matches_css_node?(css_node)
        case css_node.type
        when :CONDITIONAL_SELECTOR
          css_node.value.all? { |inner_css_node| matches_css_node?(inner_css_node) }
        when :ELEMENT_NAME
          css_node.value == ['*'] || css_node.value.include?(name)
        when :CLASS_CONDITION
          (css_node.value & classes).any?
        when :ATTRIBUTE_CONDITION
          attribute, operator, value = css_node.value

          raise "Unknown attribute condition operator in #{css_node}" if operator != :equal

          attribute_name = attribute.value
          raise "More attribute names than expected, #{attribute_name}" if attribute_name.many?

          self[attribute_name.first] == value.gsub('"', '').gsub("'", '')
        else
          raise "Unknown Nokogiri::CSS:Node type in #{css_node}"
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
    end
  end
end
