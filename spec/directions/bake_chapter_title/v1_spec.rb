require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterTitle::V1 do

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1>dummy</h1>
          <h1 data-type="document-title">chapter 1</h1>
        </div>
        <div data-type="chapter">
          <h1>dummy</h1>
          <h1 data-type="document-title">chapter 2</h1>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1)

    expect(book1.body.children.to_s).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <h1>dummy</h1>
          <h1 data-type="document-title" id="chapTitle1">
            <span class="os-part-text">Chapter </span>
            <span class="os-number">1</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">chapter 1</span>
          </h1>
        </div>
        <div data-type="chapter">
          <h1>dummy</h1>
          <h1 data-type="document-title" id="chapTitle2">
            <span class="os-part-text">Chapter </span>
            <span class="os-number">2</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">chapter 2</span>
          </h1>
        </div>
      HTML
    )
  end

end
