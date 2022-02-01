# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::ChangeSubsectionTitleTag do
  let(:section_with_subsection) do
    book_containing(html:
      <<~HTML
        <section class="whatever">
          <section>
            <h4>This title should be an h5</h4>
          </section>
          <section>
            <h4>And this</h4>
          </section>
        </section>
      HTML
    ).search('section.whatever').first
  end

  it 'changes subsection headers from h4 to h5' do
    described_class.v1(section: section_with_subsection)
    expect(section_with_subsection).to match_normalized_html(
      <<~HTML
        <section class="whatever">
          <section>
            <h5>This title should be an h5</h5>
          </section>
          <section>
            <h5>And this</h5>
          </section>
        </section>
      HTML
    )
  end
end
