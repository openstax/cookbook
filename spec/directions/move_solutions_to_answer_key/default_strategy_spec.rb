# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveSolutionsToAnswerKey::V1 do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Title for Ch1</h1>
          <div data-type="page">
            <section id="1234" class="review-questions">
              <div data-type="exercise">
                <div data-type="problem">Problem 1>Blah</div>
                <div data-type="solution">a</div>
              </div>
              <div data-type="exercise">
                <div data-type="problem">Problem 1>Blork</div>
                <div data-type="solution">b</div>
              </div>
            </section>
          </div>
        </div>
        <div data-type="chapter">
          <h1 data-type="document-title">Title for Ch2</h1>
          <div data-type="page">
            <section id="5679" class="review-questions">
              <div data-type="exercise">
                <div data-type="problem">Problem 1>Beep</div>
                <div data-type="solution">c</div>
              </div>
              <div data-type="exercise">
                <div data-type="problem">Problem 1>Voom</div>
                <div data-type="solution">d</div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="bleepbloop"></div>
      HTML
    )
  end

  it 'works' do
    book1.chapters.each do |chapter|
      described_class.new.bake(
        chapter: chapter,
        metadata_source: metadata_element,
        strategy: :default,
        append_to: append_to,
        strategy_options: { classes: %w[review-questions] }
      )
    end

    expect(append_to).to match_normalized_html(
      <<~HTML
        <div class="bleepbloop">
          <div class="os-eob os-solutions-container" data-type="composite-page" data-uuid-key=".solutions1">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 1</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Chapter 1</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div data-type="solution">a</div>
            <div data-type="solution">b</div>
          </div>
          <div class="os-eob os-solutions-container" data-type="composite-page" data-uuid-key=".solutions2">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 2</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Chapter 2</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div data-type="solution">c</div>
            <div data-type="solution">d</div>
          </div>
        </div>
      HTML
    )
  end
end
