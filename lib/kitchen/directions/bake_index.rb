module Kitchen
  module Directions
    module BakeIndex

      def self.v1(book:)
        V1.new.bake(book: book)
      end

      # # TODO
      # # 1) If have "Temperature" and "temperature", use lowercase
      # # 2) Sort "Hückel" after "Hu" and before "Hund" (e.g.)
      # # 3) Move into a V1 class

      # class Term
      #   attr_reader :text, :id, :group_by, :page_title

      #   def initialize(text:, id:, group_by:, page_title:)
      #     @text = text.strip
      #     @id = id
      #     @group_by = group_by
      #     @page_title = page_title
      #   end
      # end

      # class IndexItem
      #   attr_reader :term_text
      #   attr_reader :terms

      #   def initialize(term_text:)
      #     @term_text = term_text
      #     @terms = []
      #   end

      #   def add_term(term)
      #     @terms.push(term)
      #   end

      #   def <=>(other)
      #     (term_text.downcase <=> other.term_text.downcase).tap do |value|
      #       return term_text <=> other.term_text if value == 0
      #     end
      #   end
      # end

      # class IndexSection
      #   attr_reader :name
      #   attr_reader :items

      #   def initialize(name:)
      #     @force_first = name == I18n.t(:eob_index_symbols_group)
      #     @name = name
      #     @items = SortedSet.new
      #     @items_by_term_text = {}
      #   end

      #   def add_term(term)
      #     item_for(term).add_term(term)
      #   end

      #   def <=>(other)
      #     return -1 if force_first
      #     return 1 if other.force_first
      #     self.name <=> other.name
      #   end

      #   protected

      #   attr_reader :force_first

      #   def item_for(term)
      #     @items_by_term_text[term.text] ||= begin
      #       IndexItem.new(term_text: term.text).tap do |item|
      #         @items.add(item)
      #       end
      #     end
      #   end
      # end

      # class Index
      #   attr_reader :sections

      #   def initialize
      #     @sections = SortedSet.new
      #     @sections_by_name = {}
      #   end

      #   def add_term(term)
      #     section_named(term.group_by.capitalize).add_term(term)
      #   end

      #   protected

      #   def section_named(name)
      #     @sections_by_name[name] ||= begin
      #       IndexSection.new(name: name).tap do |section|
      #         @sections.add(section)
      #       end
      #     end
      #   end
      # end

      # def self.v1(book:)
      #   metadata_elements = book.metadata.search(%w(.authors .publishers .print-style
      #                                               .permissions [data-type='subject'])).copy
      #   index = Index.new

      #   book.pages.terms.each do |term_element|
      #     # Markup the term
      #     page = term_element.ancestor(:page)
      #     term_element.id = "auto_#{page.id}_term#{term_element.count_in(:book)}"

      #     group_by = term_element.text.strip[0]
      #     if !group_by.match? (/\w/)
      #       group_by = I18n.t(:eob_index_symbols_group)
      #     end
      #     term_element['group-by'] = group_by

      #     # Add it to our index object
      #     index.add_term(Term.new(
      #       text: term_element.text,
      #       id: term_element.id,
      #       group_by: group_by,
      #       page_title: page.title.text.gsub(/\n/,'')
      #     ))
      #   end

      #   index_sections = index.sections.map do |section|
      #     index_items = section.items.map do |item|
      #       term_locations = item.terms.map do |term|
      #         <<~HTML
      #           <a class="os-term-section-link" href="##{term.id}">
      #             <span class="os-term-section">#{term.page_title}</span>
      #           </a>
      #         HTML
      #       end.join('<span class="os-index-link-separator">, </span>')

      #       first_term = item.terms.first
      #       <<~HTML
      #         <div class="os-index-item">
      #           <span class="os-term" group-by="#{first_term.group_by}">#{first_term.text}</span>
      #           #{term_locations}
      #         </div>
      #       HTML
      #     end.join("\n")

      #     <<~HTML
      #       <div class="group-by">
      #         <span class="group-label">#{section.name}</span>
      #         #{index_items}
      #       </div>
      #     HTML
      #   end.join("\n")

      #   # Add the index page
      #   book.first("body").append(child:
      #     <<~HTML
      #     <div class="os-eob os-index-container " data-type="composite-page" data-uuid-key="index">
      #       <h1 data-type="document-title">
      #         <span class="os-text">#{I18n.t(:eob_index_title)}</span>
      #       </h1>
      #       <div data-type="metadata" style="display: none;">
      #         <h1 data-type="document-title" itemprop="name">#{I18n.t(:eob_index_title)}</h1>
      #         #{metadata_elements.paste}
      #       </div>
      #       #{index_sections}
      #     </div>
      #     HTML
      #   )
      # end

    end
  end
end
