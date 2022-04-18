# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSolutions::V1 do
  before do
    stub_locales({
      'eoc': {
        'solutions': 'Solutions'
      }
    })
  end

  let(:chapter) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h1 data-type='document-title'>Stuff and Things</h1>
            <section data-depth="1" id="0" class="free-response">
              <h3 data-type="title">HOMEWORK</h3>
              <div data-type="exercise">
                <div data-type="problem">How much wood does a wood chuck chuck?</div>
                <div data-type="solution" id='1'>
                  <p>Not much here because bakeNumberedNotes does that for us </p>
                </div>
              </div>
            </section>
            <section data-depth="1" id="0" class="practice">
              <h3 data-type="title">PRACTICE</h3>
              <div data-type="exercise">
                <div data-type="problem">What is the airspeed velocity of an unladen swallow?</div>
                <div data-type="solution" id='2'>
                  <p>Something that Numbered Notes will handle</p>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  it 'works' do
    described_class.new.bake(chapter: chapter,
                             metadata_source: metadata_element,
                             uuid_prefix: '',
                             classes: %w[free-response practice])
    expect(chapter).to match_snapshot_auto
  end

end
