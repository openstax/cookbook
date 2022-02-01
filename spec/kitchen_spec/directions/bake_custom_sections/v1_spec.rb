# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeCustomSections::V1 do

  before do
    stub_locales({
      'custom-sections': {
        'narrative-trailblazer': 'Literacy Narrative Trailblazer',
        'living-words': 'Living by Their Own Words',
        'quick-launch': 'Quick Launch',
        'drafting': 'Drafting',
        'peer-review': 'Peer Review',
        'revising': 'Revising'
        }
      })
  end

  let(:custom_sections_properties) do
    {
      living_words: {
        class: 'living-words',
        inject: 'subtitle'
      },
      narrative_trailblazer: {
        class: 'narrative-trailblazer',
        inject: 'title'
      },
      quick_launch: {
        class: 'quick-launch',
        inject: 'title_prefix'
      },
      drafting: {
        class: 'drafting',
        inject: 'title_prefix'
      },
      peer_review: {
        class: 'peer-review',
        inject: 'title_prefix'
      },
      revising: {
        class: 'revising',
        inject: 'title_prefix'
      }
    }
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div class="chapter-content-module narrative-trailblazer" data-type="page">
          <h2 data-type="document-title">
            <span class="os-number">1.2</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">Tara Westover (b. 1986)</span>
          </h2>
          <div id="id1"><!-- no-selfclose --></div>
          <section class="peer-review" data-depth="1">
            <h3 data-type="title">Giving Specific Praise and Constructive Feedback</h3>
          </section>
          <section class="quick-launch" data-depth="1">
              <h3 data-type="title">Defining Your Rhetorical Situation, Generating Ideas, and Organizing</h3>
          </section>
          <section class="living-words" data-depth="1">
            <h3 data-type="title">Literacy from Unexpected Sources</h3>
          </section>
          <section class="drafting" data-depth="1">
            <h3 data-type="title">Writing from Personal Experience and Observation</h3>
          </section>
          <section class="revising" data-depth="1">
              <h3 data-type="title">Adding and Deleting Information</h3>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(chapter: chapter, custom_sections_properties: custom_sections_properties)
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div class="chapter-content-module narrative-trailblazer" data-type="page">
            <h2 data-type="document-title">
              <span class="os-number">1.2</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Literacy Narrative Trailblazer</span>
            </h2>
            <h3 class="os-subtitle" id="id1">Tara Westover (b. 1986)</h3>
            <section class="peer-review" data-depth="1">
              <h3 data-type="title">Peer Review: Giving Specific Praise and Constructive Feedback</h3>
            </section>
            <section class="quick-launch" data-depth="1">
              <h3 data-type="title">Quick Launch: Defining Your Rhetorical Situation, Generating Ideas, and Organizing</h3>
            </section>
            <section class="living-words" data-depth="1">
              <h3 class="os-title">Living by Their Own Words</h3>
              <h4 data-type="title">Literacy from Unexpected Sources</h4>
            </section>
            <section class="drafting" data-depth="1">
              <h3 data-type="title">Drafting: Writing from Personal Experience and Observation</h3>
            </section>
            <section class="revising" data-depth="1">
              <h3 data-type="title">Revising: Adding and Deleting Information</h3>
            </section>
          </div>
        </div>
      HTML
    )
  end
end
