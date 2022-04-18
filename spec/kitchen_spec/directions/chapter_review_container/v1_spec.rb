# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::ChapterReviewContainer::V1 do
  before do
    stub_locales({
      'eoc': {
        'exercises': 'Exercises',
        'chapter-review': 'Chapter Review'
      }
    })
  end

  let(:chapter) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            This is a page
          </div>
        </div>
      HTML
    ).chapters.first
  end

  it 'works' do
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element)
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element, klass: 'exercises')
    expect(chapter).to match_snapshot_auto
  end
end
