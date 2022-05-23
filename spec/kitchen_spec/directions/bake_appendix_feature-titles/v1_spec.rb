# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAppendixFeatureTitles::V1 do

  before do
    stub_locales({
      'appendix_sections': {
        'knowledge-check': 'Knowlegde Check',
        'chapter-summary': 'Summary'
      }
    })
  end

  let(:appendix_section_with_title_to_be_changed) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="appendix">
          <section class="knowledge-check">
            <h2 data-type="title">Exercises</h2>
            <div data-type="injected-exercise">Some Exercise</div>
          </section>
        </div>
      HTML
    ).search('section').first
  end

  let(:appendix_section_without_title) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="appendix">
          <section class="chapter-summary">
            <p>Some paragraph</p>
          </section>
        </div>
      HTML
    ).search('section').first
  end

  it 'adds dynamic title' do
    described_class.new.bake(section: appendix_section_without_title, selector: 'chapter-summary')
    expect(appendix_section_without_title).to match_snapshot_auto
  end

  it 'changes existing title to dynamic' do
    described_class.new.bake(section: appendix_section_with_title_to_be_changed, selector: 'knowledge-check')
    expect(appendix_section_with_title_to_be_changed).to match_snapshot_auto
  end
end
