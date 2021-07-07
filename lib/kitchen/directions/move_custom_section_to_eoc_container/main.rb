# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
# More parameters are ok here because these generic classes DRY up a lot of other code
module Kitchen
  module Directions
    module MoveCustomSectionToEocContainer
      # Creates a custom eoc composite page for a section within the given chapter.
      # The sections are moved into this composite page, and can be transformed before the moved by an optional block argument.
      #
      # @param chapter [ChapterElement] the chapter in which the section to be moved is contained
      # @param metadata_source [MetadataElement] metadata for the book
      # @param container_key [String] Appended to 'eoc.' to form the I18n key for the container title; also used as part of a class on the container.
      # @param uuid_key [String] the uuid key for the wrapper class, e.g. `'.summary'`
      # @param section_selector [String] the selector for the section to be moved, e.g. `'section.summary'`
      # @param append_to [ElementBase] the element to be appended. Defaults to the value of `chapter` param if none given.
      # @param include_intro_page [Boolean] control the introduction page for the chapter should be searched for a section to move, default is true
      # @return [ElementBase] the append_to element with container appended
      #
      def self.v1(chapter:, metadata_source:, container_key:, uuid_key:,
                  section_selector:, append_to: nil, include_intro_page: true)
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          container_key: container_key,
          uuid_key: uuid_key,
          section_selector: section_selector,
          append_to: append_to || chapter,
          include_intro_page: include_intro_page
        ) do |section|
          yield section if block_given?
        end
      end
    end
  end
end
# rubocop:enable Metrics/ParameterLists
