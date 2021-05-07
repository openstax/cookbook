# frozen_string_literal: true

module Kitchen::Directions::BakeIndex
  # Bake directions for eob index
  #
  class V1
    renderable

    class Term
      attr_reader :text
      attr_reader :id
      attr_reader :group_by
      attr_reader :page_title

      def initialize(text:, id:, group_by:, page_title:)
        @text = text.strip
        @id = id
        @group_by = group_by
        @page_title = page_title
      end
    end

    class IndexItem
      attr_reader :term_text
      attr_reader :terms

      def initialize(term_text:)
        @term_text = term_text
        @terms = []

        # Sort by transliterated version first to support accent marks,
        # then by the raw text to support the same text with different capitalization
        @sortable = [
          ActiveSupport::Inflector.transliterate(term_text).downcase,
          term_text
        ]
      end

      def add_term(term)
        @terms.push(term)
      end

      def uncapitalize_term_text!
        @term_text = @term_text.uncapitalize
      end

      def capitalize_term_text!
        @term_text = @term_text.capitalize
      end

      def <=>(other)
        sortable <=> other.sortable
      end

      protected

      attr_reader :sortable
    end

    class IndexSection
      attr_reader :name
      attr_reader :items

      def initialize(name:)
        @force_first = name == I18n.t(:eob_index_symbols_group)
        @name = name
        @items = SortedSet.new
        @items_by_term_text = {}
      end

      def add_term(term)
        item_for(term).add_term(term)
      end

      def <=>(other)
        return -1 if force_first
        return 1 if other.force_first

        name <=> other.name
      end

      protected

      attr_reader :force_first

      def item_for(term)
        @items_by_term_text[term.text] ||= begin
          different_caps_item = @items_by_term_text[term.text.uncapitalize]
          different_caps_item&.uncapitalize_term_text!

          unless different_caps_item
            different_caps_item = @items_by_term_text[term.text.capitalize]
            different_caps_item&.capitalize_term_text!
          end

          (different_caps_item || IndexItem.new(term_text: term.text)).tap do |item|
            @items.add(item)
          end
        end
      end
    end

    class Index
      attr_reader :sections

      def initialize
        @sections = SortedSet.new
        @sections_by_name = {}
      end

      def add_term(term)
        section_named(term.group_by.capitalize).add_term(term)
      end

      protected

      def section_named(name)
        @sections_by_name[name] ||= begin
          IndexSection.new(name: name).tap do |section|
            @sections.add(section)
          end
        end
      end
    end

    def bake(book:)
      @metadata_elements = book.metadata.children_to_keep.copy
      @index = Index.new

      book.pages.terms.each do |term_element|
        page = term_element.ancestor(:page)
        term_element.id = "auto_#{page.id}_term#{term_element.count_in(:book)}"
        page_title = page.title.text
        add_term_to_index(term_element, page_title)
      end

      book.chapters.composite_pages.terms.each do |term_element|
        page = term_element.ancestor(:composite_page)
        chapter = term_element.ancestor(:chapter)
        term_element.id = "auto_composite_page_term#{term_element.count_in(:book)}"
        chapter_number = chapter.count_in(:book)
        page_title = "#{chapter_number} #{page.title.text.strip}".strip
        add_term_to_index(term_element, page_title)
      end

      book.first('body').append(child: render(file: 'v1.xhtml.erb'))
    end

    def add_term_to_index(term_element, page_title)
      group_by = term_element.text.strip[0]
      group_by = I18n.t(:eob_index_symbols_group) unless group_by.match?(/\w/)
      term_element['group-by'] = group_by

      # Add it to our index object
      @index.add_term(
        Term.new(
          text: term_element.text,
          id: term_element.id,
          group_by: group_by,
          page_title: page_title.gsub(/\n/, '')
        )
      )
    end

  end
end
