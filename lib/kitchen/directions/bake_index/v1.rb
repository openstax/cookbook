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
        I18n.sort_strings(term_text, other.term_text)
      end
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

        I18n.sort_strings(name, other.name)
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

    def bake(book:, types: %w[main], uuid_prefix: '')
      @metadata_elements = book.metadata.children_to_keep.copy
      @uuid_prefix = uuid_prefix
      @indexes = types.each.with_object({}) do |type, hash|
        index_name = type == 'main' ? 'term' : type
        hash[index_name] = Index.new
      end

      # Numbering of IDs doesn't depend on term type

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

      types.each do |type|
        @container_class = "os-index#{"-#{type}" unless type == 'main'}-container"
        @uuid_key = "#{uuid_prefix}index#{"-#{type}" unless type == 'main'}"
        @title = I18n.t("index.#{type}")

        index_name = type == 'main' ? 'term' : type
        @index = @indexes[index_name]

        book.first('body').append(child: render(file: 'v1.xhtml.erb'))
      end
    end

    def add_term_to_index(term_element, page_title)
      type =
        if !term_element.key?('index')
          'term'
        elsif term_element['cxlxt:index'] == 'name'
          'name'
        elsif term_element['cxlxt:index'] == 'foreign'
          'foreign'
        end

      if term_element.key?('reference')
        term_reference = term_element['cmlnle:reference']
        group_by = term_reference[0]
        content = term_reference
      else
        group_by = I18n.character_to_group(term_element.text.strip[0])
        content = term_element.text
      end

      group_by = I18n.t(:eob_index_symbols_group) unless group_by.match?(/[[:alpha:]]/)
      term_element['group-by'] = group_by

      # Add it to our index object
      @indexes[type].add_term(
        Term.new(
          text: content,
          id: term_element.id,
          group_by: group_by,
          page_title: page_title.gsub(/\n/, '')
        )
      )
    end

  end
end
