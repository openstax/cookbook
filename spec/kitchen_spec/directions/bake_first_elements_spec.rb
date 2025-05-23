# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFirstElements do
  let(:book) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="exercise" id="bla1">
            <div data-type="problem" id="bla2">
              <span class="os-number">28</span>
              <span class="os-divider">. </span>
              <div class="os-problem-container">
                <span data-alt="An image ..." data-type="media" id="bla3">
                  <img alt="some text" data-media-type="image/jpeg" id="bla4" src="bla.jpg" />
                  <p>do not bake me</p>
                </span>
              </div>
            </div>
          </div>
          <section class="section-exercises" id="sectionId">
            <p id="bla5">For the following exercises...</p>
            <div class="os-hasSolution" data-type="exercise" id="bla6">
              <div data-type="problem" id="bla7">
                <a class="os-number" href="#bla11">1</a>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <div class="os-table">
                    <table class="unnumbered" data-label="" id="bla8">
                      <p>some content</p>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla1">
              <div data-type="problem" id="bla2">
                <span class="os-number">28</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <span data-alt="An image..." data-type="media" id="bla3">
                    <img alt="some text" data-media-type="image/jpeg" id="bla4" src="bla.jpg" />
                  </span>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla1">
              <div data-type="problem" id="bla2">
                <div class="os-problem-container">
                  <span data-alt="An image..." data-type="media" id="bla3">
                    <p>something</p>
                  </span>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla6">
              <div data-type="problem" id="bla7">
                <span class="os-number">22</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p id="bla8">
                    <span class="os-math-in-para">
                      <p>some content</p>
                    </span>
                  </p>
                  <div class="os-table">
                    <table class="unnumbered" data-label="" id="table1">
                      <div>do not bake this content</div>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla7">
              <div data-type="problem"/>
              <div data-type="solution">
                <div class="os-solution-container">
                  <span data-type="media">Media</span>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla8">
              <div data-type="problem"/>
              <div data-type="solution">
                <div class="os-solution-container">
                  <div data-type="not media">bla10</div>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla9">
              <div data-type="solution"><div class="os-solution-container">
                <ol class="circled" id="" type="1">
                  <li><span class="token">&#x24D0;</span> yes</li>
                  <li><span class="token">&#x24D1;</span> yes. (Note: If two players had been tied for, say, 4th place, then the name would not have been a function of rank.)</li>
                </ol>
              </div></div>
            </div>
            <div data-type="exercise" id="bla10">
              <div data-type="problem">
                <div class="os-problem-container">
                  <ol class="circled" id="" type="a">
                    <li>don't add a class to this one</li>
                  </ol>
                  <ol class="circled" id="" type="1">
                    <li><span class="token">&#x24D0;</span> yes</li>
                  </ol>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla11">
              <div data-type="problem">
                <div class="os-problem-container">
                  <ol class="circled" id="" type="1">
                    <li>do add a class to this one</li>
                  </ol>
                </div>
              </div>
            </div>
            <div data-type="exercise" id="bla12">
              <div data-type="problem">
                <div class="os-problem-container">
                  <div class="os-figure" data-type="media" id="fig1">
                    <figure>something</figure>
                  </div>
                </div>
              </div>
            </div>
            <div data-type="injected-exercise" id="bla13">
              <div data-type="exercise-question">
                <div class="os-problem-container">
                  <div data-type="question-stimulus">
                    <img alt="some text" data-media-type="image/jpeg" id="bla5" src="bla5.jpg" />
                  </div>
                </div>
              </div>
            </div>
          </section>
        HTML
      )
    )
  end

  it 'works with first_inline_list' do
    section = book.search('.section-exercises').first
    described_class.v1(within: section, first_inline_list: true)

    expect(book.body).to match_snapshot_auto
  end

  it 'works without first_inline_list' do
    section = book.first('[id="bla9"]')
    described_class.v1(within: section)
    expect(section).to match_snapshot_auto
  end
end
