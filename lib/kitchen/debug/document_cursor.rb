module Kitchen
  module Debug
    class DocumentCursor
      def self.current_node=(node)
        @current_node = node
      end

      def self.current_node
        @current_node
      end
    end
  end
end
