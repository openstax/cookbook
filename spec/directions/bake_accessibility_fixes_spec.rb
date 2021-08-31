# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAccessibilityFixes do

  let(:type_a) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <section data-depth="1" class="multiple-choice">
            <h3 data-type="title">Multiple Choice</h3>
            <div data-type="exercise">
              <div data-type="problem">
                <div>A company should accept a project if</div>
                <ol data-number-style="lower-alpha">
                  <li>the NPV of the project is positive.</li>
                  <li>the NPV of the project is negative.</li>
                </ol>
              </div>
            </div>
            <div data-type="exercise">
              <div data-type="problem">
              <div>The net present value of a project equals</div>
                <ol data-number-style="lower-alpha">
                  <li>the future value of the cash inflows minus the future value of the cash outflows.</li>
                  <li>the present value of the cash inflows minus the future value of the cash inflows.</li>
                </ol>
              </div>
            </div>
          </section>
        HTML
      )
    )
  end

  describe 'v1' do
    it 'works' do
      described_class.v1(section: type_a)
      expect(type_a.chapters.first).to match_normalized_html(
        <<~HTML
          <div data-type="chapter">
            <div data-type="page">
              <section data-depth="1" class="multiple-choice">
                <h3 data-type="title">Multiple Choice</h3>
                <div data-type="exercise">
                  <div data-type="problem">
                    <div>A company should accept a project if</div>
                    <ol data-number-style="lower-alpha" type="a">
                      <li>the NPV of the project is positive.</li>
                      <li>the NPV of the project is negative.</li>
                    </ol>
                  </div>
                </div>
                <div data-type="exercise">
                  <div data-type="problem">
                  <div>The net present value of a project equals</div>
                    <ol data-number-style="lower-alpha" type="a">
                      <li>the future value of the cash inflows minus the future value of the cash outflows.</li>
                      <li>the present value of the cash inflows minus the future value of the cash inflows.</li>
                    </ol>
                  </div>
                </div>
              </section>
            </div>
          </div>
        HTML
      )
    end
  end

end
