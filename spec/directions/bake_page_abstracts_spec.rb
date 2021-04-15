# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakePageAbstracts do
  before do
    stub_locales({
      'learning_objectives': 'Learning Objectives'
    })
  end

  let(:chapter) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 title</h1>
          <div data-type="page" class="introduction">Chapter intro</div>
          <div data-type="page" class="chapter-content-module">
            <h2 data-type="document-title">Module 1.1 title</div>
            <div data-type="abstract">
              By the end of this module, you will be able to:
                <ul>
                  <li>Outline the historical development of chemistry</li>
                  <li>Provide examples of the importance of chemistry in everyday life</li>
                </ul>
              </div>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  it 'adds Learning Objectives h3' do
    described_class.v1(chapter: chapter)
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 title</h1>
          <div class="introduction" data-type="page">Chapter intro</div>
          <div class="chapter-content-module" data-type="page">
            <h2 data-type="document-title">Module 1.1 title</h2>
            <div data-type="abstract">
              <h3 data-type="title">Learning Objectives</h3>
              By the end of this module, you will be able to:
                <ul><li>Outline the historical development of chemistry</li><li>Provide examples of the importance of chemistry in everyday life</li></ul>
              </div>
          </div>
        </div>
      HTML
    )
  end

  it 'adds abstract-token and abstract-content' do
    described_class.v2(chapter: chapter)
    expect(chapter.non_introduction_pages).to match_normalized_html(
      <<~HTML
        <div class="chapter-content-module" data-type="page">
          <h2 data-type="document-title">Module 1.1 title</h2>
          <div data-type="abstract"><h3 data-type="title">Learning Objectives</h3>
              By the end of this module, you will be able to:
                <ul class="os-abstract"><li><span class="os-abstract-token">1.1.1</span><span class="os-abstract-content">Outline the historical development of chemistry</span></li><li><span class="os-abstract-token">1.1.2</span><span class="os-abstract-content">Provide examples of the importance of chemistry in everyday life</span></li></ul>
              </div>
        </div>
      HTML
    )
  end
end
