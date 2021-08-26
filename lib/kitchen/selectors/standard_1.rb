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
        self.page_summary               = 'section.summary'
        self.reference                  = '.reference'
        self.chapter                    = "div[data-type='chapter']"
        self.page                       = "div[data-type='page']"
        self.note                       = "div[data-type='note']"
        self.term                       = "span[data-type='term']"
        self.table                      = 'table'
        self.figure                     = 'figure'
        self.metadata                   = "div[data-type='metadata']"
        self.composite_page             = "div[data-type='composite-page']"
        self.composite_chapter          = "div[data-type='composite-chapter']"
        self.example                    = "div[data-type='example']"
        self.exercise                   = "div[data-type='exercise']"
        self.unit                       = "div[data-type='unit']"
        self.solution                   = "div[data-type='solution'], " \
                                          "div[data-type='question-solution']"
        self.injected_question          = "div[data-type='exercise-question']"
      end

    end
  end
end
