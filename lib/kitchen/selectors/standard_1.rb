module Kitchen
  module Selectors
    class Standard1 < Base

      def initialize
        self.title_in_page              = "./*[@data-type = 'document-title']"
        self.title_in_introduction_page = "./*[@data-type = 'document-title']"
      end

    end
  end
end
