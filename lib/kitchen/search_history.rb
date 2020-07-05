module Kitchen
  class SearchHistory
    attr_reader :latest
    attr_reader :upstream

    def self.empty
      new
    end

    def add(css_or_xpath)
      self.class.new(self, css_or_xpath.nil? ? nil : [css_or_xpath].join(", "))
    end

    def to_s(missing_string="?")
      to_a.map{|item| "[#{item || missing_string}]"}.join(" ")
    end

    def to_a
      empty? ? [] : [upstream&.to_a || [], latest].flatten
    end

    def empty?
      upstream.nil? && latest.nil?
    end

    protected

    def initialize(upstream=nil, latest=nil)
      @upstream = upstream
      @latest = latest
    end
  end
end
