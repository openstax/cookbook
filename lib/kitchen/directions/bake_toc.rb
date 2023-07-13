# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeToc
      def self.v1(book:, options: { cases: false })
        options.reverse_merge!(
          cases: false
        )

        li_tags = book.body.element_children.map do |element|
          case element
          when UnitElement
            li_for_unit(element, options)
          when ChapterElement
            li_for_chapter(element, options)
          when PageElement, CompositePageElement
            li_for_page(element)
          when CompositeChapterElement
            li_for_composite_chapter(element)
          end
        end.compact.join("\n")

        # the greater than switch happens in this piece of code
        book.first!('nav').replace_children(with: <<~HTML
          <h1 class="os-toc-title">#{I18n.t(:toc_title)}</h1>
          <ol>
            #{li_tags}
          </ol>
        HTML
        )

      end

      def self.li_for_unit(unit, options)
        chapters = unit.element_children.only(ChapterElement)
        pages = unit.element_children.only(PageElement)

        <<~HTML
          <li cnx-archive-uri="" cnx-archive-shortid="" class="os-toc-unit" data-toc-type="unit">
            <a href="#">
              <span class="os-number"><span class="os-part-text">#{I18n.t(:unit)} </span>#{unit.count_in(:book)}</span>
              <span class="os-divider"> </span>
              <span data-type="" itemprop="" class="os-text">#{unit.title_text}</span>
            </a>
            <ol class="os-unit">
              #{pages.map { |page| li_for_page(page) }.join("\n")}
              #{chapters.map { |chapter| li_for_chapter(chapter, options) }.join("\n")}
            </ol>
          </li>
        HTML
      end

      def self.li_for_composite_chapter(composite_chapter)
        pages = composite_chapter.element_children.only(CompositePageElement)

        <<~HTML
          <li class="os-toc-composite-chapter" cnx-archive-shortid="" cnx-archive-uri="" data-toc-type="sub-book-tree">
            <a href="##{composite_chapter.title.id}">
              #{composite_chapter.title.children}
            </a>
            <ol class="os-chapter">
              #{pages.map { |page| li_for_page(page) }.join("\n")}
            </ol>
          </li>
        HTML
      end

      def self.li_for_chapter(chapter, options)
        chapter_children = chapter.element_children.map do |child|
          if child.instance_of?(PageElement) || child.instance_of?(CompositePageElement)
            li_for_page(child)
          elsif child.instance_of?(CompositeChapterElement)
            li_for_composite_chapter(child)
          end
        end.join("\n")

        <<~HTML
          <li class="os-toc-chapter" cnx-archive-shortid="" cnx-archive-uri="" data-toc-type="chapter">
            <a href="##{chapter.title.id}">
              <span class="os-number"><span class="os-part-text">#{I18n.t("chapter#{'.nominative' \
              if options[:cases]}")} </span>#{chapter.count_in(:book)}</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">#{chapter.title.first!('.os-text').text}</span>
            </a>
            <ol class="os-chapter">
              #{chapter_children}
            </ol>
          </li>
        HTML
      end

      def self.li_for_page(page)
        # rubocop:disable Style/WordArray
        # li_page_type is for styling, toc_target_type is for rex toc markup
        (li_page_type, toc_target_type) =
          case page
          when PageElement
            if page.has_ancestor?(:chapter)
              if page.is_introduction?
                ['os-toc-chapter-page', 'intro']
              else
                ['os-toc-chapter-page', 'numbered-section']
              end
            elsif page.is_appendix?
              ['os-toc-appendix', 'appendix']
            elsif page.is_preface?
              ['os-toc-preface', 'preface']
            elsif page.is_handbook?
              ['os-toc-handbook', 'appendix']
            elsif page.has_ancestor?(:unit) && !
                  page.has_ancestor?(:chapter) && !
                  page.has_ancestor?(:composite_chapter)
              ['os-toc-unit-page', 'intro']
            else
              raise "could not detect which page type class to apply for page.id `#{page.id}`
               during baking the TOC. The classes on the page are: `#{page.classes}`
               #{page.say_source_or_nil}"
            end
          when CompositePageElement
            if page.is_index? || page.is_index_of_type?
              ['os-toc-index', 'index']
            elsif page.is_citation_reference?
              ['os-toc-reference', 'composite-page']
            elsif page.is_section_reference?
              ['os-toc-references', 'composite-page']
            elsif page.has_ancestor?(:composite_chapter) && \
                  page.ancestor(:composite_chapter).is_answer_key?
              ['os-toc-chapter-composite-page', 'answer-key']
            elsif page.has_ancestor?(:composite_chapter) || page.has_ancestor?(:chapter)
              ['os-toc-chapter-composite-page', 'composite-page']
            else
              raise "could not detect which composite page type class to apply to TOC for page id \
              `#{page.id}` during baking the TOC. The classes on the page are: `#{page.classes}`
              #{page.say_source_or_nil}"
            end
          else
            raise(ArgumentError, "could not detect any page type class to apply for `#{page.id}`" \
                                  "during baking TOC#{page.say_source_or_nil}")
          end
        # rubocop:enable Style/WordArray

        title = page.title.copy

        # The part text gets inserted as a child to the number span
        part_text = title.first('.os-part-text')
        number = title.first('.os-number')
        if part_text && number
          part_text = part_text.cut
          number.prepend(child: part_text.paste)
        end

        <<~HTML
          <li class="#{li_page_type}" cnx-archive-shortid="" cnx-archive-uri="#{page.id}" data-toc-type="book-content" data-toc-target-type="#{toc_target_type}">
            <a href="##{page.id}">
              #{title.element_children.copy.paste}
            </a>
          </li>
        HTML
      end
    end
  end
end
