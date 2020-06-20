module Kitchen
  class IterationHistory

    # What we really need:
    #   an elements parent
    #     my_element.ancestor(:page)
    #   the count of the element type in each of the ancestors
    #     my_element.number_in(:book)


    # class Node
    #   def initialize(element:, parent: nil)
    #     @name = element.iteration_history_name
    #     @parent = parent
    #     @element = element
    #     @sub_nodes = []
    #   end

    #   def add_sub_node(element)
    #     @sub_nodes.push(Node.new(element: element, parent: self))
    #   end

    #   def add(element)
    #     case element.iteration_history_name
    #       @name
    #       # add to parent
    #     elsif
    #   end



    # end



    attr_reader :current_level_name

    def initialize(element: nil)
      # @root_node = Node.new(element)
      # @last_node = @root_node
      # @current_level_name = nil
    end

    def record(element)
      # new_node = Node.new(element: element)

      # if @last_node.name != new_node.name
      # if current_level_name != name
      #   @cursor.push
      # end

      # @cursor.push(element)
    end


  end
end
