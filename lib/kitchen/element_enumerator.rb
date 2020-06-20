module Kitchen
  class ElementEnumerator < Enumerator

    attr_reader :iteration_history

    def initialize(iteration_history: nil)
      @iteration_history || IterationHistory.new
      super(nil) # TODO is there a way to calculate the size lazily?
    end

    def cut
      clipboard = Clipboard.new
      self.each do |element|
        element.cut(to: clipboard)
      end
      clipboard
    end

    def counts
      @counts ||= {}
    end

    def [](index)
      to_a[index]
    end

    # def each
    #   debugger

    #   super.tap do |thing|
    #     puts thing.class
    #   end
    # end



  end
end
