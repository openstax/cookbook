# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BookAnswerKeyContainer::V1 do
  let(:book) do
    book_containing(html:
      <<~HTML
        #{metadata(title: 'Book Title')}
        <div data-type="chapter">
          <div data-type="page">
            This is a page
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    expect(described_class.new.bake(book: book)).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-solutions-container" data-type="composite-chapter" data-uuid-key=".solutions">
          <h1 data-type="document-title">
            <span class="os-text">Answer Key</span>
          </h1>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Answer Key</h1>
            <div class="authors">
            <span id="author-1_copy_1"><a>OpenStaxCollege</a></span>
          </div><div class="publishers">
            <span id="publisher-1_copy_1"><a>OpenStaxCollege</a></span>
          </div><div class="print-style">
            <span data-type="print-style">ccap-calculus</span>
          </div><div class="permissions">
            <p class="copyright">
              <span id="copyright-holder-1_copy_1"><a>OSCRiceUniversity</a></span>
            </p>
            <p class="license">
              <a>CC BY</a>
            </p>
          </div><div itemprop="about" data-type="subject">Math</div>
          </div>
        </div>
      HTML
    )
  end

  def metadata(title:, id_suffix: '')
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <h1 data-type="document-title" itemprop="name">#{title}</h1>
        <div class="authors">
          <span id="author-1#{id_suffix}" ><a>OpenStaxCollege</a></span>
        </div>
        <div class="publishers">
          <span id="publisher-1#{id_suffix}"><a>OpenStaxCollege</a></span>
        </div>
        <div class="print-style">
          <span data-type="print-style">ccap-calculus</span>
        </div>
        <div class="permissions">
          <p class="copyright">
            <span id="copyright-holder-1#{id_suffix}"><a>OSCRiceUniversity</a></span>
          </p>
          <p class="license">
            <a>CC BY</a>
          </p>
        </div>
        <div itemprop="about" data-type="subject">Math</div>
      </div>
    HTML
  end
end
