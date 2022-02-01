# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::RemoveSectionTitle do
  let(:section_with_h3) do
    book_containing(html:
      <<~HTML
        <section class="whatever">
          <h3 data-type="title">A spare title</h3>
          <div>content</div>
        </section>
      HTML
    ).search('section').first
  end

  it 'removes the stray title from a section' do
    described_class.v1(section: section_with_h3)
    expect(section_with_h3).to match_normalized_html(
      <<~HTML
        <section class="whatever">
          <div>content</div>
        </section>
      HTML
    )
  end
end
