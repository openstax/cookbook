# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeLearningObjectives do
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

  let(:chapter_with_learning_objectives) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 title</h1>
          <div data-type="page" class="introduction">Chapter intro</div>
          <div data-type="page" class="chapter-content-module">
            <h2 data-type="document-title">Module 1.1 title</div>
            <section data-type="learnin-objectives">
              By the end of this module, you will be able to:
                <ul>
                  <li>Outline the historical development of chemistry</li>
                  <li>Provide examples of the importance of chemistry in everyday life</li>
                </ul>
              </section>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  let(:chapter_with_more_data) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 title</h1>
          <div data-type="page" class="introduction">
            <div class="intro-body">
              <div class="os-chapter-outline">
                <h3 class="os-title">Chapter Outline</h3>
                <div class="os-chapter-objective">
                  <a class="os-chapter-objective">link to page 1.1</a>
                </div>
                <div class="os-chapter-objective">
                </div>
                <div class="os-chapter-objective">
                </div>
              </div>
            </div>
          </div>
          <div data-type="page" class="chapter-content-module">
            <h2 data-type="document-title">Module 1.1 title</div>
            <div data-type="abstract">
              <ul><li>1.1 abstract</li></ul>
            </div>
          </div>
          <div data-type="page" class="chapter-content-module">
            <h2 data-type="document-title">Module 1.2 title</div>
            <div data-type="abstract">1.2 abstract</div>
          </div>
          <div data-type="page" class="chapter-content-module">
            <h2 data-type="document-title">Module 1.3 title</div>
            <div data-type="abstract">1.3 abstract</div>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  let(:appendix_page_with_lo) do
    book_containing(html:
      <<~HTML
        <div class="appendix" data-type="page">
          <h1 data-type="document-title">Appendix Test</h1>
          <section class="learning-objectives">
            <h2 data-type="title">Learning Outcomes</h2>
            <p>By the end of this module, you will be able to</p>
              <ul>
                <li>Describe ethical issues related to consumer buying behavior.</li>
                <li>Identify the characteristics of an ethical consumer</li>
              </ul>
          </section>
        </div>
      HTML
    ).pages.first
  end

  it 'adds Learning Objectives h3' do
    described_class.v1(chapter: chapter)
    expect(chapter).to match_snapshot_auto
  end

  it 'adds abstract-token and abstract-content' do
    described_class.v2(chapter: chapter)
    expect(chapter.non_introduction_pages.to_s).to match_snapshot_auto
  end

  it 'works if chapter for chapter with learning objctives' do
    described_class.v2(chapter: chapter_with_learning_objectives)
    expect(chapter_with_learning_objectives.non_introduction_pages.to_s).to match_snapshot_auto
  end

  it 'works for v3' do
    described_class.v3(chapter: chapter_with_more_data)
    expect(chapter_with_more_data).to match_snapshot_auto
  end

  it 'bakes lo in appendices' do
    described_class.v2(chapter: appendix_page_with_lo, li_numbering: :in_appendix)
    expect(appendix_page_with_lo).to match_snapshot_auto
  end

  context 'when only li need to be counted' do
    it 'works' do
      described_class.v2(chapter: chapter, li_numbering: :count_only_li)
      expect(chapter).to match_snapshot_auto
    end
  end

  context 'when only li need to be counted in appendix' do
    it 'works' do
      described_class.v2(chapter: appendix_page_with_lo, li_numbering: :count_only_li_in_appendix)
      expect(appendix_page_with_lo).to match_snapshot_auto
    end
  end
end
