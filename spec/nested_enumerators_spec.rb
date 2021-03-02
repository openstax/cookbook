# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'nested enumerators' do

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="page" id="p1">
          <span data-type="term" id="p1t1">sharks</span>
        </div>
        <div data-type="chapter" id="c1">
          <div data-type="page" id="c1p1">
            <span data-type="term" id="c1p1t1">howdy</span>
          </div>
          <div data-type="page" id="c1p2"></div>
        </div>
        <div data-type="chapter" id="c2">
          <div data-type="page" id="c2p1">
            <span data-type="term" id="c2p1t1">yoyo</span>
            <span data-type="term" id="c2p1t2">ma</span>
          </div>
          <div data-type="page" id="c2p2">
            <span data-type="term" id="c2p2t1">lasers</span>
          </div>
        </div>
      HTML
    )
  end

  # TODO: see if we do any weird iteration in tutorials and spec them here

  context 'when performing single-level iteration' do
    it 'can iterate over chapters' do
      expect(book1.chapters.map(&:id)).to eq %w[c1 c2]
    end

    it 'can iterate over pages' do
      expect(book1.pages.map(&:id)).to eq %w[p1 c1p1 c1p2 c2p1 c2p2]
    end

    it 'can iterate over terms' do
      expect(book1.terms.map(&:id)).to eq %w[p1t1 c1p1t1 c2p1t1 c2p1t2 c2p2t1]
    end

    it 'records counts within ancestors' do
      expect(book1.terms.map { |t| t.count_in(:book) }).to eq [1, 2, 3, 4, 5]
    end

    it 'records counts for abitrary searches' do
      expect(book1.search('span').map { |t| t.count_in(:book) }).to eq [1, 2, 3, 4, 5]
    end
  end

  context 'when performing multi-level iteration' do
    describe 'basic operation' do
      it 'can iterate over chapters and then pages' do
        expect(book1.chapters.pages.map(&:id)).to eq %w[c1p1 c1p2 c2p1 c2p2]
      end

      it 'can iterate over chapters then pages then terms' do
        expect(book1.chapters.pages.terms.map(&:id)).to eq %w[c1p1t1 c2p1t1 c2p1t2 c2p2t1]
      end
    end

    context 'when ancestors are available' do
      it 'can access the book from an iterated chapter' do
        book1.chapters.each do |chapter|
          expect(chapter.ancestor(:book)).to eq book1
        end
      end

      it 'can access the book and chapter from an iterated page' do
        expect(book1.chapters.pages[1].ancestor(:chapter).id).to eq 'c1'
        expect(book1.chapters.pages[2].ancestor(:chapter).id).to eq 'c2'
      end
    end

    it 'records counts within ancestors' do
      expect(book1.pages.terms.map { |t| t.count_in(:book) }).to eq [1, 2, 3, 4, 5]
    end

    it 'records counts within reused ancestor element (like book)' do
      expect(book1.pages.terms.map { |t| t.count_in(:book) }).to eq [1, 2, 3, 4, 5]
      expect(book1.pages.terms.map { |t| t.count_in(:book) }).to eq [1, 2, 3, 4, 5]
    end

    it 'counts for multiple ancestors' do
      expect(book1.pages.terms.map do |t|
        [t.count_in(:book), t.count_in(:page)]
      end).to eq [[1, 1], [2, 1], [3, 1], [4, 2], [5, 1]]
    end

    it 'records counts when enumerator ancestors are reused' do
      enumerator = book1.pages

      expect(enumerator.terms.map { |t| t.count_in(:page) }).to eq [1, 1, 1, 2, 1]
      expect(enumerator.terms.map { |t| t.count_in(:page) }).to eq [1, 1, 1, 2, 1]
      expect(enumerator.terms.map { |t| t.count_in(:book) }).to eq [1, 2, 3, 4, 5]
      expect(enumerator.terms.map { |t| t.count_in(:book) }).to eq [1, 2, 3, 4, 5]
    end

    context 'when enumerators broken up with individual element access' do
      it 'can access ancestors all the way up the ancestry' do
        book1.chapters.each do |chapter|
          chapter.pages.each do |page|
            expect(page.ancestor(:chapter).id).to eq chapter.id
            expect(page.ancestor(:book).name).to eq 'html'
          end
        end
      end

      it 'counts correctly with single use of individual elements' do
        counts = book1.chapters.map do |chapter|
          chapter.pages.map do |p|
            [p.count_in(:chapter), p.count_in(:book)]
          end
        end

        expect(counts).to eq [[[1, 1], [2, 2]], [[1, 3], [2, 4]]]
      end

      it 'counts correctly with repeated iteration calls on the same element' do
        counts = []
        book1.chapters.each do |chapter|
          # rubocop:disable Style/CombinableLoops
          chapter.pages.each do |page|
            counts.push(page.count_in(:chapter))
            counts.push(page.count_in(:book))
          end

          chapter.pages.each do |page|
            # Don't want these counts to be doubled
            counts.push(page.count_in(:chapter))
            counts.push(page.count_in(:book))
          end
          # rubocop:enable Style/CombinableLoops
        end
        # first chapter      second chapter
        expect(counts).to eq [1, 1, 2, 2, 1, 1, 2, 2] + [1, 3, 2, 4, 1, 3, 2, 4]
      end
    end

  end

end
