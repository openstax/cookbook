# frozen_string_literal: true

module Kitchen
  module Selectors
    # A specific set of selectors
    #
    class Standard1 < Base

      # Create a new instance
      #
      def initialize
        super
        self.title_in_page              = "./*[@data-type = 'document-title']"
        self.title_in_introduction_page = "./*[@data-type = 'document-title']"
      end

    end
  end
end
