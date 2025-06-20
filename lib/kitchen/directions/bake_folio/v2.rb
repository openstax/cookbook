# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFolio
      class V2
        renderable

        class FolioParaWithNumber
          attr_reader :klass
          attr_reader :title
          attr_reader :title_number
          attr_reader :append_to

          def initialize(klass:, title:, title_number:, append_to:)
            @klass = klass
            @title = title
            @title_number = title_number
            @append_to = append_to
          end

          def create_para
            title_divider = ' • '
            para_text = [
              @title_number&.strip,
              @title.strip
            ].compact.join(title_divider)

            @append_to.append(sibling:
              <<~HTML.chomp
                <p class="#{@klass}">
                  #{para_text}
                </p>
              HTML
            )
          end
        end

        class FolioPara
          attr_reader :klass
          attr_reader :title

          def initialize(klass:, title:)
            @klass = klass
            @title = title
          end

          def create_para
            title_label = @title.search('.os-text').first.children

            @title.append(sibling:
              <<~HTML.chomp
                <p class="#{@klass}">#{title_label}</p>
              HTML
            )
          end
        end

        def bake(book:, chapters:)
          book['data-pdf-folio-preface-message'] = I18n.t(:"folio.preface")
          book['data-pdf-folio-access-message'] = I18n.t(:"folio.access_for_free")

          # TODO: apply to all books and remove an option
          chapters.each do |chapter|
            chapter_folio(chapter: chapter)
            module_folio(chapter: chapter)
            eoc_folio(chapter: chapter, klass: 'folio-eoc-left')
            eoc_folio(chapter: chapter, klass: 'folio-eoc-right')
          end

          appendix_folio(book: book, klass: 'folio-appendix-left')
          appendix_folio(book: book, klass: 'folio-appendix-right')

          eob_folio(book: book, klass: 'folio-eob-left')
          eob_folio(book: book, klass: 'folio-eob-right')
        end

        def chapter_folio(chapter:)
          chapter_number = chapter.search('$[data-type="document-title"] > .os-number').first
          chapter_para = FolioParaWithNumber.new(
            klass: 'folio-chapter',
            title: chapter.title_text,
            title_number: chapter_number&.text,
            append_to: chapter.title
          )

          chapter_para.create_para
        end

        def module_folio(chapter:)
          # Introduction para
          chapter_number = chapter.search('$[data-type="document-title"] > .os-number').first
          chapter.pages('$.introduction').each do |page|
            title_element = page.search('h2[data-type="document-title"]').first
            intro_para = FolioParaWithNumber.new(
              klass: 'folio-module',
              title: page.title_text,
              title_number: chapter_number&.text,
              append_to: title_element
            )

            intro_para.create_para
          end

          # Module para
          chapter.non_introduction_pages.each do |page|
            title_element = page.search('h2[data-type="document-title"]').first
            title_number = title_element.search('$.os-number').first&.text
            module_para = FolioParaWithNumber.new(
              klass: 'folio-module',
              title: page.title_text,
              title_number: title_number,
              append_to: title_element
            )

            module_para.create_para
          end
        end

        def eoc_folio(chapter:, klass:)
          chapter_number = chapter.search('$[data-type="document-title"] > .os-number').first
          chapter.search(' > .os-eoc').each do |eoc_page|
            title_element = eoc_page.search('h2[data-type="document-title"]').first
            eoc_para = FolioParaWithNumber.new(
              klass: klass,
              title: title_element.text,
              title_number: chapter_number&.text,
              append_to: title_element
            )

            eoc_para.create_para
          end
        end

        def appendix_folio(book:, klass:)
          book.pages('$.appendix').each do |appendix_page|
            appendix_para = FolioParaWithNumber.new(
              klass: klass,
              title: appendix_page.title.text,
              title_number: [*('A'..'Z')][appendix_page.count_in(:book) - 1],
              append_to: appendix_page.title
            )

            appendix_para.create_para
          end
        end

        def eob_folio(book:, klass:)
          eob_selectors = '.os-eob[data-type="composite-chapter"], ' \
                         '.os-eob[data-type="composite-page"]:not(.os-solutions-container)'

          book.search(eob_selectors).each do |eob_page|
            eob_para = FolioPara.new(
              klass: klass,
              title: eob_page.search('h1[data-type="document-title"]').first
            )

            eob_para.create_para
          end
        end
      end
    end
  end
end
