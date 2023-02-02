# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::UseSectionTitle do

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div class="os-chemistry-matters-container" data-type="page">
          <h2 data-type="document-title">
            <span class="os-text">Chemistry Matters</span>
          </h2>
          <section class="chemistry-matters">
            <h3 data-type="title">Organic Foods: Risk versus Benefit</h3>
          </section>
          <section class="chemistry-matters">
              <h3 data-type="title">Defining Your Rhetorical Situation, Generating Ideas, and Organizing</h3>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(chapter: chapter, eoc_selector: '.os-chemistry-matters-container', section_selector: 'section.chemistry-matters')
    expect(chapter).to match_snapshot_auto
  end
end
