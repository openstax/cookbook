require 'spec_helper'

RSpec.describe Kitchen::PageElement do

  let(:page_title_text) { "A title!"}

  let(:metadata) do
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <h1 data-type="document-title" itemprop="name">#{page_title_text}</h1>
      </div>
    HTML
  end

  let(:page_1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          #{metadata}
          <div data-type="document-title">#{page_title_text}</div>
        HTML
      )
    ).pages.first
  end

  context "#title" do
    context "no metadata" do
      let(:metadata) { "" }

      it "finds the title" do
        expect(page_1.title.text).to eq page_title_text
      end
    end

    context "with metadata" do
      it "finds the title" do
        expect(page_1.title.text).to eq page_title_text
      end
    end
  end

end
