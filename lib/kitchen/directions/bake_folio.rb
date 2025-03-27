# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFolio
      def self.v1(book:, chapters: nil, options: {})
        options.reverse_merge!(
          new_approach: false,
          numbering_options: { mode: :chapter_page, separator: '.' })
        V1.new.bake(
          book: book,
          chapters: chapters || book.chapters,
          options: options)
      end

      class V1
        renderable

        class FolioParaWithNumber
          attr_reader :klass
          attr_reader :title
          attr_reader :title_number

          def initialize(klass:, title:, title_number:)
            @klass = klass
            @title = title
            @title_number = title_number
          end

          def create_para
            title_divider = ' • '
            title_label = @title.search('.os-text').first.children

            @title.append(sibling:
              <<~HTML.chomp
                <p class="#{@klass}">
                  #{@title_number}#{title_divider}#{title_label}
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

        def bake(book:, chapters:, options:)
          book['data-pdf-folio-preface-message'] = I18n.t(:"folio.preface")
          book['data-pdf-folio-access-message'] = I18n.t(:"folio.access_for_free")

          return unless options[:new_approach]

          # TODO: apply to all books and remove an option
          numbering_options = options[:numbering_options]
          chapters.each do |chapter|
            chapter_folio(chapter: chapter, numbering_options: numbering_options)
            module_folio(chapter: chapter, numbering_options: numbering_options)
            eoc_folio(
              chapter: chapter,
              klass: 'folio-eoc-left',
              numbering_options: numbering_options
            )
            eoc_folio(
              chapter: chapter,
              klass: 'folio-eoc-right',
              numbering_options: numbering_options
            )
          end

          appendix_folio(book: book, klass: 'folio-appendix-left')
          appendix_folio(book: book, klass: 'folio-appendix-right')

          eob_folio(book: book, klass: 'folio-eob-left')
          eob_folio(book: book, klass: 'folio-eob-right')
        end

        def chapter_folio(chapter:, numbering_options:)
          chapter_para = FolioParaWithNumber.new(
            klass: 'folio-chapter',
            title: chapter.title,
            title_number: chapter.os_number(numbering_options)
          )

          chapter_para.create_para
        end

        def module_folio(chapter:, numbering_options:)
          # Introduction para
          chapter.pages('$.introduction').each do |page|
            intro_para = FolioParaWithNumber.new(
              klass: 'folio-module',
              title: page.search('h2[data-type="document-title"]').first,
              title_number: chapter.os_number(numbering_options)
            )

            intro_para.create_para
          end

          # Module para
          chapter.non_introduction_pages.each do |page|
            module_para = FolioParaWithNumber.new(
              klass: 'folio-module',
              title: page.title,
              title_number: page.os_number(numbering_options)
            )

            module_para.create_para
          end
        end

        def eoc_folio(chapter:, klass:, numbering_options:)
          chapter.search(' > .os-eoc').each do |eoc_page|
            eoc_para = FolioParaWithNumber.new(
              klass: klass,
              title: eoc_page.search('h2[data-type="document-title"]').first,
              title_number: chapter.os_number(numbering_options)
            )

            eoc_para.create_para
          end
        end

        def appendix_folio(book:, klass:)
          book.pages('$.appendix').each do |appendix_page|
            appendix_para = FolioParaWithNumber.new(
              klass: klass,
              title: appendix_page.title,
              title_number: [*('A'..'Z')][appendix_page.count_in(:book) - 1]
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
