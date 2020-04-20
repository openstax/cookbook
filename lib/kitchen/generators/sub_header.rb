module Kitchen
  module Generators

    def sub_header(node:, attributes: {}, content: "")
      first_header = node.search("h1, h2, h3, h4, h5, h6").first

      tag_name = first_header.nil? ?
                 "h1" :
                 first_header.name.gsub(/\d/) {|num| (num.to_i + 1).to_s}

      container(name: tag_name, attributes: attributes) do
        block_given? ? yield : content
      end
    end

    module_function :sub_header

  end
end
