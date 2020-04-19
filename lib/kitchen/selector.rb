module Kitchen
  class Selector

    def self.expand(selector)
      selector.gsub(/h\*/,'h1, h2, h3, h4, h5, h6')
    end

  end
end
