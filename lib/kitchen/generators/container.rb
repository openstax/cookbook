module Kitchen
  module Generators

    def container(name:, attributes: {}, content: "")
      attributes_string = attributes.map do |key, value|
        key.to_s.gsub!('_','-')
        "#{key}='#{value}'"
      end.join(" ")

      <<~HTML
        <#{name} #{attributes_string}>
          #{block_given? ? yield : content}
        </#{name}>
      HTML
    end

    module_function :container

  end
end
