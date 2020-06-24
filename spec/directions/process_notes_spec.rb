require 'spec_helper'

RSpec.describe Kitchen::Directions::ProcessNotes do

  let(:book_with_titled_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId">
            <div data-type="title" id="titleId"><em>Answer:</em></div>
            <p id="pId">Blah</p>
          </div>
        HTML
      )
    )
  end

  let(:book_with_untitled_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId" class="chemistry link-to-learning">
            <p id="pId">Blah</p>
          </div>
        HTML
      )
    )
  end

  context "v1" do
    let(:book) { book_with_titled_note }

    context "with title" do
      it "works" do
        described_class.v1(book: book)

        expect(book.elements("[data-type='note']").first).to match_html(
          <<~HTML
            <div data-type="note" id="noteId">
              <h3 class="os-title" data-type="title">
                <span data-type="" id="titleId" class="os-title-label"><em>Answer:</em></span>
              </h3>
              <div class="os-note-body">
                <p id="pId">Blah</p>
              </div>
            </div>
          HTML
        )
      end
    end

    context "without title" do
      let(:book) { book_with_untitled_note }

      it "works" do
        described_class.v1(book: book)

        expect(book.elements("[data-type='note']").first).to match_html(
          <<~HTML
            <div data-type="note" id="noteId" class="chemistry link-to-learning">
              <h3 class="os-title" data-type="title">
                <span class="os-title-label">Link to Learning</span>
              </h3>
              <div class="os-note-body">
                <p id="pId">Blah</p>
              </div>
            </div>
          HTML
        )
      end
    end

  end
end
