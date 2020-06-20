# Make debug output more useful (dumping entire document out is not useful)
module Nokogiri
  module XML
    class Document
      def inspect
        "<hidden for brevity>"
      end
    end

    class Node
      def inspect
        to_s
      end
    end
  end
end
