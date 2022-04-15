# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeSuggestedReading do

  let(:sample_chapter) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="metadata" style="display: none;">
            <p> I am metadata chap 1</p>
          </div>
          <span>This is a page</span>
          <section class="suggested-reading">
            <p>Books:</p>
            <p>Dahl, Robert A. 1991. <em data-effect="italics">Democracy and Its Critics</em>.</p>
            <p>———. 1961. <em data-effect="italics"></em>.</p>
            <p>Films:</p>
            <p>1949. <em data-effect="italics">All the King’s Men</em>.</p>
            <p>1976. <em data-effect="italics">All the President’s Men</em>.</p>
          </section>
        HTML
      )
    )
  end

  it 'works' do
    described_class.v1(book: sample_chapter)

    expect(sample_chapter.search('div[data-type="chapter"]').to_s).to match_snapshot_auto
  end
end
