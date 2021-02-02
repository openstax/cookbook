# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeMathInParagraph do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <div>
          <p>
            <math>
              <msup>
                <mn>10</mn>
                <mn>3</mn>
              </msup>
            </math>
          </p>
        </div>
      HTML
    )
  end

  let(:book2) do
    book_containing(html:
      <<~HTML
        <div>
          <p>
            <m>
              <msup>
                <mn>10</mn>
                <mn>3</mn>
              </msup>
            </m>
          </p>
        </div>
      HTML
    )
  end

  let(:book3) do
    book_containing(html:
      <<~HTML
        <div>
          <p>
            <span>
              <math>
                <msup>
                  <mn>10</mn>
                  <mn>3</mn>
                </msup>
              </math>
            </span>
          </p>
        </div>
      HTML
    )
  end

  it 'works with math tags' do
    described_class.v1(book: book1)
    expect(
      book1.body.children.to_s
    ).to match_normalized_html(
      <<~HTML
        <div>
          <p>
            <span class="os-math-in-para">
              <math>
                <msup>
                  <mn>10</mn>
                  <mn>3</mn>
                </msup>
              </math>
            </span>
          </p>
        </div>
      HTML
    )
  end

  it 'works with m tags' do
    described_class.v1(book: book2)
    expect(
      book2.body.children.to_s
    ).to match_normalized_html(
      <<~HTML
        <div>
          <p>
            <span class="os-math-in-para">
              <m>
                <msup>
                  <mn>10</mn>
                  <mn>3</mn>
                </msup>
              </m>
            </span>
          </p>
        </div>
      HTML
    )
  end

  it 'works with math tags wrapped by 2 elements' do
    described_class.v1(book: book3)
    expect(
      book3.body.children.to_s
    ).to match_normalized_html(
      <<~HTML
        <div>
          <p>
            <span>
              <span class="os-math-in-para">
                <math>
                  <msup>
                    <mn>10</mn>
                    <mn>3</mn>
                  </msup>
                </math>
              </span>
            </span>
          </p>
        </div>
      HTML
    )
  end
end
