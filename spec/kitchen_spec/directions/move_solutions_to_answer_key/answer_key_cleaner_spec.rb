# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::AnswerKeyCleaner do
  let(:book) do
    book_containing(html:
      <<~HTML
        <div class="os-eob os-solution-container" data-type="composite-chapter">
          <h1 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">Answer Key</span>
          </h1>
          <div class="os-eob os-solution-container" data-type="composite-page">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 1</span>
            </h2>
            <div data-type="solution" id="sol1">
              <a class="os-number" href="#something">1</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container">
                <p>D</p>
              </div>
            </div>
            <div data-type="solution" id="sol2">
              <a class="os-number" href="#something">2</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container">
                <p>A</p>
              </div>
            </div>
            <div data-type="solution" id="sol3">
              <a class="os-number" href="#something">3</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container">
                <p>C</p>
              </div>
            </div>
          </div>
          <div class="os-eob os-solution-container" data-type="composite-page">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 2</span>
            </h2>
          </div>
        </div>
      HTML
    )
  end

  it 'removes container without solutions' do
    described_class.v1(book: book)
    expect(book.first('.os-eob[data-type="composite-chapter"]').to_s).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-solution-container" data-type="composite-chapter">
          <h1 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">Answer Key</span>
          </h1>
          <div class="os-eob os-solution-container" data-type="composite-page">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 1</span>
            </h2>
            <div data-type="solution" id="sol1">
              <a class="os-number" href="#something">1</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container">
                <p>D</p>
              </div>
            </div>
            <div data-type="solution" id="sol2">
              <a class="os-number" href="#something">2</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container">
                <p>A</p>
              </div>
            </div>
            <div data-type="solution" id="sol3">
              <a class="os-number" href="#something">3</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container">
                <p>C</p>
              </div>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
