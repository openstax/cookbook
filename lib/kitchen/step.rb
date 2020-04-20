module Kitchen
  class Step

    include Kitchen::Generators

    def initialize(node:)
      @node = node
    end

    def each(*selector_or_xpath_args, &block)
      Steps::Each.new(node: node!, selector_or_xpath_args: selector_or_xpath_args, &block).do_it
    end

    def first(*selector_or_xpath_args, &block)
      Steps::First.new(node: node!, selector_or_xpath_args: selector_or_xpath_args,
                       raise_if_missing: false, &block).do_it
    end

    def first!(*selector_or_xpath_args, &block)
      Steps::First.new(node: node!, selector_or_xpath_args: selector_or_xpath_args,
                       raise_if_missing: true, &block).do_it
    end

    def cut(to: :default)
      Steps::Cut.new(node: node!, to: to).do_it
    end

    def copy(to: :default, &block)
      block_given? ?
        Steps::Copy.new(node: node!, to: to, &block).do_it :
        Steps::Copy.new(node: node!, to: to).do_it
    end

    def paste(from: :default)
      Kitchen::Clipboard.named(from).paste
    end

    def trash
      node!.remove
    end

    def prepend_child(child:)
      Steps::PrependChild.new(node: node!, child: child).do_it
    end

    def append_child(child:)
      Steps::AppendChild.new(node: node!, child: child).do_it
    end

    def replace_children(with:)
      Steps::ReplaceChildren.new(node: node!, with: with).do_it
    end

    def count(name)
      Kitchen::Counter.increment(name)
    end

    def reset_count(name)
      Kitchen::Counter.reset(name)
    end

    def get_count(name)
      Kitchen::Counter.read(name)
    end

    def set_name(name)
      node!.name = name
    end

    def get_attribute(name)
      node![name]
    end

    def content(*selector_or_xpath_args)
      node!.search(*selector_or_xpath_args).children.to_s
    end

    def children(*selector_or_xpath_args)
      node!.search(*selector_or_xpath_args).children
    end

    def pantry
      Pantry.instance
    end

    alias_method :original_sub_header, :sub_header

    def sub_header(attributes: {}, content: "")
      original_sub_header(node: node!, attributes: attributes) do
        block_given? ? yield : content
      end
    end

    protected

    attr_reader :node

    def node!
      node || raise("node is requested but not available")
    end

  end
end
