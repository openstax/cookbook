module Kitchen
  class SearchHistory

    def self.empty
      new
    end

    def add(css_or_xpath)
      self.class.new(@items.dup + [css_or_xpath])
    end

    def to_s(missing_string="?")
      @items.map{|item| item.nil? ? missing_string : item}.join(" ")
    end

    protected

    def initialize(items=[])
      @items = items
    end

  end
end
