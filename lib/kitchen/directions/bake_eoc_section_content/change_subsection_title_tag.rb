# frozen_string_literal: true

module Kitchen
  module Directions
    module ChangeSubsectionTitleTag
      def self.v1(section:)
        section.search('section').each do |subsection|
          subsection.first('h4').name = 'h5'
        end
      end
    end
  end
end
