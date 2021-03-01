# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeStepwise do

  before do
    stub_locales({
      'stepwise_step_label': 'Step'
    })
  end

  let(:book_1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <ol class="stepwise">
            <li>content1</li>
            <li>content2</li>
          </ol>
          <ol class="stepwise">
            <li>content3</li>
          </ol>
        HTML
      )
    )
  end

  it 'works' do
    described_class.v1(book: book_1)

    expect(book_1.search('ol').to_s).to match_normalized_html(
      <<~HTML
        <ol class="os-stepwise">
          <li>
            <span class="os-stepwise-token">Step 1. </span>
            <span class="os-stepwise-content">content1</span>
          </li>
          <li>
            <span class="os-stepwise-token">Step 2. </span>
            <span class="os-stepwise-content">content2</span>
          </li>
        </ol>
        <ol class="os-stepwise">
          <li>
            <span class="os-stepwise-token">Step 1. </span>
            <span class="os-stepwise-content">content3</span>
          </li>
        </ol>
      HTML
    )

  end

end
