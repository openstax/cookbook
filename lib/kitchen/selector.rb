# frozen_string_literal: true

module Kitchen
  # A wrapper for a selector.  Can be used as the default_css_or_xpath.
  #
  class Selector < Proc
    attr_reader :name

    def self.named(name)
      @instances ||= {}
      @instances[name] ||= new(name) { |config| config.selectors.send(name) }
    end

    def initialize(name, &block)
      @name = name
      super(&block)
    end

    def matches?(node, config:)
      # This may not be incredibly efficient as it does a search of this node's
      # ancestors to see if the node is in the results.  Watch the performance.
      node.quick_matches?(call(config))
    end
  end
end
