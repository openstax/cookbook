# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeToc
      def self.v1(book:)
        li_tags = book.body.element_children.map do |element|
          case element
          when UnitElement
            li_for_unit(element)
          when ChapterElement
            li_for_chapter(element)
          when PageElement, CompositePageElement
            li_for_page(element)
          when CompositeChapterElement
            li_for_composite_chapter(element)
          end
        end.compact.join("\n")

        book.first!('nav').replace_children(with: <<~HTML
          <h1 class="os-toc-title">#{I18n.t(:toc_title)}</h1>
          <ol>
            #{li_tags}
          </ol>
        HTML
        )
      end

      def self.li_for_unit(unit)
        chapters = unit.element_children.only(ChapterElement)
        pages = unit.element_children.only(PageElement)

        <<~HTML
          <li cnx-archive-uri="" cnx-archive-shortid="" class="os-toc-unit">
            <a href="#">
              <span class="os-number"><span class="os-part-text">#{I18n.t(:unit)} </span>#{unit.count_in(:book)}</span>
              <span class="os-divider"> </span>
              <span data-type itemprop class="os-text">#{unit.title_text}</span>
            </a>
            <ol class="os-unit">
              #{pages.map { |page| li_for_page(page) }.join("\n")}
              #{chapters.map { |chapter| li_for_chapter(chapter) }.join("\n")}
            </ol>
          </li>
        HTML
      end

      def self.li_for_composite_chapter(chapter)
        pages = chapter.element_children.only(CompositePageElement)

        <<~HTML
          <li class="os-toc-composite-chapter" cnx-archive-shortid="" cnx-archive-uri="">
            <a href="##{chapter.title.id}">
              #{chapter.title.children}
            </a>
            <ol class="os-chapter">
              #{pages.map { |page| li_for_page(page) }.join("\n")}
            </ol>
          </li>
        HTML
      end

      def self.li_for_chapter(chapter)
        pages = chapter.element_children.only(PageElement, CompositePageElement)
        inner_composite_chapters = chapter.element_children.only(CompositeChapterElement)

        <<~HTML
          <li class="os-toc-chapter" cnx-archive-shortid="" cnx-archive-uri="">
            <a href="##{chapter.title.id}">
              <span class="os-number"><span class="os-part-text">#{I18n.t(:chapter)} </span>#{chapter.count_in(:book)}</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">#{chapter.title.first!('.os-text').text}</span>
            </a>
            <ol class="os-chapter">
              #{pages.map { |page| li_for_page(page) }.join("\n")}
              #{
                inner_composite_chapters.map do |composite_chapter|
                  li_for_composite_chapter(composite_chapter)
                end.join("\n")
              }
            </ol>
          </li>
        HTML
      end

      def self.li_for_page(page)
        li_class =
          case page
          when PageElement
            if page.has_ancestor?(:chapter)
              'os-toc-chapter-page'
            elsif page.is_appendix?
              'os-toc-appendix'
            elsif page.is_preface?
              'os-toc-preface'
            elsif page.is_handbook?
              'os-toc-handbook'
            elsif page.has_ancestor?(:unit) && !
                  page.has_ancestor?(:chapter) && !
                  page.has_ancestor?(:composite_chapter)
              'os-toc-unit-page'
            else
              raise "could not detect which page type class to apply for page.id `#{page.id}`
               during baking the TOC. The classes on the page are: `#{page.classes}`"
            end
          when CompositePageElement
            if page.is_index? || page.is_index_of_type?
              'os-toc-index'
            elsif page.is_citation_reference?
              'os-toc-reference'
            elsif page.is_section_reference?
              'os-toc-references'
            elsif page.has_ancestor?(:composite_chapter) || page.has_ancestor?(:chapter)
              'os-toc-chapter-composite-page'
            else
              raise "could not detect which composite page type class to apply to TOC for page id \
              `#{page.id}` during baking the TOC. The classes on the page are: `#{page.classes}`"
            end
          else
            raise(ArgumentError, "could not detect any page type class to apply for `#{page.id}` \
            during baking TOC")
          end

        title = page.title.copy

        # The part text gets inserted as a child to the number span
        part_text = title.first('.os-part-text')
        number = title.first('.os-number')
        if part_text && number
          part_text = part_text.cut
          number.prepend(child: part_text.paste)
        end

        <<~HTML
          <li class="#{li_class}" cnx-archive-shortid="" cnx-archive-uri="#{page.id}">
            <a href="##{page.id}">
              #{title.element_children.copy.paste}
            </a>
          </li>
        HTML
      end
    end
  end
end
