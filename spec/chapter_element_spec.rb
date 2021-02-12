# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::ChapterElement do
  let(:sample_chapter) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div class="introduction" data-type="page">
            stuff
          </div>
          <div data-type="page">
            <div data-type="document-title">section 1</div>
            <div data-type="abstract">abstract 1</div>
          </div>
          <div data-type="page">
            <div data-type="document-title">section 2</div>
            <div data-type="abstract">abstract 2</div>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  describe '#abstracts' do
    it 'gets the abstracts as enumerator' do
      expect(sample_chapter.abstracts).to be_instance_of(Kitchen::ElementEnumerator)
    end

    it 'gets the correct elements' do
      expect(sample_chapter.abstracts.first).to match_normalized_html('<div data-type="abstract">abstract 1</div>')
    end
  end
end
