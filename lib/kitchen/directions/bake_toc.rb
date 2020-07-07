module Kitchen
  module Directions
    module BakeToc

      def self.v1(book:)
        li_tags = book.element_children.map do |element|
          li_for_element(element)
        end.join("\n")

        <<~HTML
          <nav id="toc">
            <h1 class="os-toc-title">Contents</h1>
            <ol>
              #{li_tags}
            </ol>
          </nav>
        HTML
      end

      def self.li_for_element(element)
        case element
        when ChapterElement
          li_for_chapter(element)
        end
      end

      def self.li_for_chapter(chapter)
        pages = book.element_children

        <<~HTML
          <li class="os-toc-chapter" cnx-archive-shortid="" cnx-archive-uri="">
            <a href="##{element.id}">
              <span class="os-number"><span class="os-part-text">Chapter </span>1</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">#{chapter.title.text}</span>
            </a>
            <ol class="os-chapter">
              #{lis_for_chapter_pages(chapter.element_children)}
            </ol>
          </li>
        HTML
      end

      def self.li_for_chapter_pages(pages)
        pages.map do |page|
          page
          <<~HTML
            <li class="os-toc-chapter-page" cnx-archive-shortid="" cnx-archive-uri="#{page.id}">
              <a href="##{page.id}">
                <span class="os-text" data-type="" itemprop="">Introduction</span>
              </a>
            </li>
          HTML
        end.join("\n")
      end

    end
  end
end
