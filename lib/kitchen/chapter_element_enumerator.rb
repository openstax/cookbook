module Kitchen
  class ChapterElementEnumerator < ElementEnumerator
    # def pages
    #   puts "Chapter.pages A"
    #   # here we need to know how many pages there have been in the enumerators earlier in the chain
    #   PageElementEnumerator.new do |block|
    #     puts "Chapter.pages B"
    #     self.each do |chapter|
    #       puts "Chapter.pages C"
    #       PageElementEnumerator.within(chapter).each do |t|
    #         puts "Chapter.pages D"
    #         block.yield(t)
    #       end
    #     end
    #   end
    # end

    def pages
      PageElementEnumerator.chained_to_enumerator(self)
    end

    # def self.within(parent)
    #   ChapterElementEnumerator.new do |block|
    #     # TODO parent should provide page selector

    #     parent.each("div[data-type='chapter']") do |element|
    #       chapter = ChapterElement.new(element: element)

    #       block.yield(chapter)
    #     end
    #   end
    # end

    def self.within(element:, iteration_history: nil)
      new(iteration_history: iteration_history) do |block|
        ancestor_for_element = Ancestor.new(element)

        element.each("div[data-type='chapter']") do |sub_element|
          chapter = ChapterElement.new(element: sub_element)
          chapter.add_ancestors(element.ancestors, ancestor_for_element) # TODO need element.self_as_ancestor that is memoized?
          block.yield(chapter)
        end
      end
    end

    def self.chained_to_enumerator(other_enumerator)
      iteration_history = other_enumerator.iteration_history

      new(iteration_history: iteration_history) do |block|
        other_enumerator.each do |element| # TODO this can be a method on base class
          within(element: element, iteration_history: iteration_history).each do |chapter|
            block.yield(chapter)
          end
        end
      end
    end

  end
end
