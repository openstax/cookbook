# frozen_string_literal: true

RSpec.describe Kitchen::Directions::BakeEquations do
  let(:book_with_equations) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="equation" class="unnumbered" id="aaa">
            <p>do nothing</p>
          </div>
          <div data-type="equation" id="123">
            <p>equation 1</p>
          </div>
        </div>
        <div data-type="chapter">
          <div data-type="equation" id="456">
            <p>4+4=8</p>
          </div>
          <div data-type="equation" id="789">
            <p>e=mc^2</p>
          </div>
        </div>
      HTML
    )
  end

  let(:book_with_one_equation) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="equation" id="123">
            <p>equation 1</p>
          </div>
        </div>
      HTML
    )
  end

  it 'bakes' do
    described_class.v1(book: book_with_equations)
    expect(book_with_equations.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="chapter">
            <div data-type="equation" class="unnumbered" id="aaa">
              <p>do nothing</p>
            </div>
            <div data-type="equation" id="123">
              <p>equation 1</p>
              <div class="os-equation-number">
                <span class="os-number">1.1</span>
              </div>
            </div>
          </div>
          <div data-type="chapter">
            <div data-type="equation" id="456">
              <p>4+4=8</p>
              <div class="os-equation-number">
                <span class="os-number">2.1</span>
              </div>
            </div>
            <div data-type="equation" id="789">
              <p>e=mc^2</p>
              <div class="os-equation-number">
                <span class="os-number">2.2</span>
              </div>
            </div>
          </div>
        </body>
      HTML
    )
  end

  it 'stores link text' do
    pantry = book_with_one_equation.document.pantry(name: :link_text)
    expect(pantry).to receive(:store).with('Equation 1.1', { label: '123' })
    described_class.v1(book: book_with_one_equation)
  end
end
