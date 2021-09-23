# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExample do

  before do
    stub_locales({
      'example': 'Example',
      'solution': 'Solution'
    })
  end

  let(:exercise) { '' }
  let(:table) { '' }
  let(:title) { '<span data-type="title">example title becomes h4</span>' }
  let(:example) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
            <div data-type='example' id='example-test'>
              #{title}
              <p>content</p>
              #{exercise}
              #{table}
            </div>
          </div>
        </div>
      HTML
    ).chapters.pages.examples.first
  end

  it 'works' do
    described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
    expect(example).to match_normalized_html(
      <<~HTML
        <div data-type="example" id="example-test">
          <title-tag-name class="os-title">
            <span class="os-title-label">Example </span>
            <span class="os-number">4</span>
            <span class="os-divider"> </span>
          </title-tag-name>
          <div class="body">
            <h4 data-type="title">example title becomes h4</h4>
            <p>content</p>
          </div>
        </div>
      HTML
    )
  end

  context 'when there is an exercise' do
    let(:exercise) do
      <<~HTML
        <div data-type="exercise" id="exercise_id">
          <div data-type="problem" id="problem_id">
            <div data-type="title" id="title_id">Evaluating Functions</div>
            <p>example content</p>
          </div>
          <div data-type="solution" id="solution_id">
            <p>Solution content</p>
          </div>
          <div data-type="commentary" id="commentary_id">
            <div data-type="title" id="title_id">Analysis</div>
          </div>
        </div>
      HTML
    end

    it 'works' do
      described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
      expect(example).to match_normalized_html(
        <<~HTML
          <div data-type="example" id="example-test">
            <title-tag-name class="os-title">
              <span class="os-title-label">Example </span>
              <span class="os-number">4</span>
              <span class="os-divider"> </span>
            </title-tag-name>
            <div class="body">
              <h4 data-type="title">example title becomes h4</h4>
              <p>content</p>
              <div data-type="exercise" id="exercise_id" class="unnumbered">
                <div data-type="problem" id="problem_id">
                  <div class="os-problem-container">
                    <h4 data-type="title" id="title_id">Evaluating Functions</h4>
                    <p>example content</p>
                  </div>
                </div>
                <div data-type="solution" id="solution_id">
                  <h4 data-type="solution-title">
                    <span class="os-title-label">Solution </span>
                  </h4>
                  <div class="os-solution-container">
                    <p>Solution content</p>
                  </div>
                </div>
                <div data-type="commentary" id="commentary_id">
                  <h4 data-type="commentary-title" id="title_id">
                    <span class="os-title-label">Analysis</span>
                  </h4>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when there is a list with a title inside the exercise commentary' do
    let(:exercise) do
      <<~HTML
        <div data-type="exercise" id="exercise_id">
          <div data-type="problem" id="problem_id">
            <div data-type="title" id="title_id">Evaluating Functions</div>
            <p>example content</p>
          </div>
          <div data-type="solution" id="solution_id">
            <p>Solution content</p>
          </div>
          <div data-type="commentary" id="commentary_id">
            <div data-type="list" id="list_id">
              <div data-type="title" id="title_id">List Title</div>
              <ul>
                <li>List Item</li>
              </ul>
            </div>
          </div>
        </div>
      HTML
    end

    it 'works' do
      described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
      expect(example).to match_normalized_html(
        <<~HTML
          <div data-type="example" id="example-test">
            <title-tag-name class="os-title">
              <span class="os-title-label">Example </span>
              <span class="os-number">4</span>
              <span class="os-divider"> </span>
            </title-tag-name>
            <div class="body">
              <h4 data-type="title">example title becomes h4</h4>
              <p>content</p>
              <div data-type="exercise" id="exercise_id" class="unnumbered">
                <div data-type="problem" id="problem_id">
                  <div class="os-problem-container">
                    <h4 data-type="title" id="title_id">Evaluating Functions</h4>
                    <p>example content</p>
                  </div>
                </div>
                <div data-type="solution" id="solution_id">
                  <h4 data-type="solution-title">
                    <span class="os-title-label">Solution </span>
                  </h4>
                  <div class="os-solution-container">
                    <p>Solution content</p>
                  </div>
                </div>
                <div data-type="commentary" id="commentary_id">
                  <div data-type="list" id="list_id">
                    <h4 data-type="title" id="title_id">List Title</h4>
                    <ul>
                      <li>List Item</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when there is an example with multiple solutions' do
    let(:exercise) do
      <<~HTML
        <div data-type="exercise" id="exercise_id">
          <div data-type="problem" id="problem_id">
            <div data-type="title" id="title_id">Evaluating Functions</div>
            <p>example content</p>
          </div>
          <div data-type="solution" id="solution_id_1">
            <p>Solution content</p>
          </div>
          <div data-type="solution" id="solution_id_2">
            <p>A second solution</p>
          </div>
          <div data-type="commentary" id="commentary_id">
            <div data-type="title" id="title_id">Analysis</div>
          </div>
        </div>
      HTML
    end

    it 'works' do
      described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
      expect(example).to match_normalized_html(
        <<~HTML
          <div data-type="example" id="example-test">
            <title-tag-name class="os-title">
              <span class="os-title-label">Example </span>
              <span class="os-number">4</span>
              <span class="os-divider"> </span>
            </title-tag-name>
            <div class="body">
              <h4 data-type="title">example title becomes h4</h4>
              <p>content</p>
              <div data-type="exercise" id="exercise_id" class="unnumbered">
                <div data-type="problem" id="problem_id">
                  <div class="os-problem-container">
                    <h4 data-type="title" id="title_id">Evaluating Functions</h4>
                    <p>example content</p>
                  </div>
                </div>
                <div data-type="solution" id="solution_id_1">
                  <h4 data-type="solution-title">
                    <span class="os-title-label">Solution </span>
                  </h4>
                  <div class="os-solution-container">
                    <p>Solution content</p>
                  </div>
                </div>
                <div data-type="solution" id="solution_id_2">
                  <h4 data-type="solution-title">
                    <span class="os-title-label">Solution </span>
                  </h4>
                  <div class="os-solution-container">
                    <p>A second solution</p>
                  </div>
                </div>
                <div data-type="commentary" id="commentary_id">
                  <h4 data-type="commentary-title" id="title_id">
                    <span class="os-title-label">Analysis</span>
                  </h4>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when there is a baked table' do
    let(:table) do
      <<~HTML
        <div class="os-table">
          <table class="some-class" id="tId">
            <thead>
              <tr>
                <th>A title</th>
              </tr>
              <tr>
                <th>Another heading cell</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>One lonely cell</td>
              </tr>
            </tbody>
          </table>
          <div class="os-caption-container">
            <span class="os-title-label">Table </span>
            <span class="os-number">S</span>
            <span class="os-divider"> </span>
            <span class="os-caption">
              <span data-type="title">Secret Title</span>
            </span>
          </div>
        </div>
      HTML
    end

    it 'doesn\'t affect the baked table' do
      described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
      expect(example).to match_normalized_html(
        <<~HTML
          <div data-type="example" id="example-test">
            <title-tag-name class="os-title">
              <span class="os-title-label">Example </span>
              <span class="os-number">4</span>
              <span class="os-divider"> </span>
            </title-tag-name>
            <div class="body">
              <h4 data-type="title">example title becomes h4</h4>
              <p>content</p>
              #{table}
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when there is an unbaked table' do
    let(:table) do
      <<~HTML
        <div class="os-table">
          <table class="some-class" id="tId">
            <thead>
              <tr>
                <th>A title</th>
              </tr>
              <tr>
                <th>Another heading cell</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>One lonely cell</td>
              </tr>
            </tbody>
            <caption>
              <span data-type="title">Secret Title</span>
            </caption>
          </table>
        </div>
      HTML
    end

    it 'doesn\'t affect the unbaked table' do
      described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
      expect(example).to match_normalized_html(
        <<~HTML
          <div data-type="example" id="example-test">
            <title-tag-name class="os-title">
              <span class="os-title-label">Example </span>
              <span class="os-number">4</span>
              <span class="os-divider"> </span>
            </title-tag-name>
            <div class="body">
              <h4 data-type="title">example title becomes h4</h4>
              <p>content</p>
              #{table}
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when there is more than one exercise with solutions' do
    let(:exercise) do
      <<~HTML
        <div data-type="exercise" id="exercise_id">
          <div data-type="problem" id="problem_id">
            <div data-type="title" id="title_id">Evaluating Functions</div>
            <p>example content</p>
          </div>
          <div data-type="solution" id="solution_id">
            <p>Solution One Content</p>
          </div>
          <div data-type="commentary" id="commentary_id">
            <div data-type="title" id="title_id">Analysis</div>
          </div>
        </div>
        <div data-type="exercise" id="exercise_id">
          <div data-type="problem" id="problem_id">
            <div data-type="title" id="title_id">Evaluating Functions</div>
            <p>example content</p>
          </div>
          <div data-type="solution" id="solution_id">
            <p>Solution Two Content</p>
          </div>
        </div>
      HTML
    end

    it 'numbers the solutions correctly when numbered_solutions true' do
      described_class.v1(
        example: example,
        number: 4,
        title_tag: 'title-tag-name',
        numbered_solutions: true
      )
      expect(example).to match_normalized_html(
        <<~HTML
          <div data-type="example" id="example-test">
            <title-tag-name class="os-title">
              <span class="os-title-label">Example </span>
              <span class="os-number">4</span>
              <span class="os-divider"> </span>
            </title-tag-name>
            <div class="body">
              <h4 data-type="title">example title becomes h4</h4>
              <p>content</p>
              <div data-type="exercise" id="exercise_id" class="unnumbered">
                <div data-type="problem" id="problem_id">
                  <div class="os-problem-container">
                    <h4 data-type="title" id="title_id">Evaluating Functions</h4>
                    <p>example content</p>
                  </div>
                </div>
                <div data-type="solution" id="solution_id">
                  <h4 data-type="solution-title">
                    <span class="os-title-label">Solution </span>
                    <span class="os-number">1</span>
                  </h4>
                  <div class="os-solution-container">
                    <p>Solution One Content</p>
                  </div>
                </div>
                <div data-type="commentary" id="commentary_id">
                  <h4 data-type="commentary-title" id="title_id">
                    <span class="os-title-label">Analysis</span>
                  </h4>
                </div>
              </div>
              <div class="unnumbered" data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <div class="os-problem-container">
                    <h4 data-type="title" id="title_id">Evaluating Functions</h4>
                    <p>example content</p>
                  </div>
                </div>
                <div data-type="solution" id="solution_id">
                  <h4 data-type="solution-title">
                    <span class="os-title-label">Solution </span>
                    <span class="os-number">2</span>
                  </h4>
                  <div class="os-solution-container">
                    <p>Solution Two Content</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when the title is a div' do
    let(:title) do
      <<~HTML
        <div data-type="title">also works on divs</div>
      HTML
    end

    it 'works' do
      described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
      expect(example).to match_normalized_html(
        <<~HTML
          <div data-type="example" id="example-test">
            <title-tag-name class="os-title">
              <span class="os-title-label">Example </span>
              <span class="os-number">4</span>
              <span class="os-divider"> </span>
            </title-tag-name>
            <div class="body">
              <h4 data-type="title">also works on divs</h4>
              <p>content</p>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when there are nested examples' do
    let(:book_with_nested_examples) do
      book_containing(html:
        one_chapter_with_one_page_containing(
          <<~HTML
            <div data-type='example' id='example-test'>
              <div data-type='example' id='example-test2'>
                <div data-type='exercise'>
                  <div data-type='problem'>Q</div>
                  <div data-type='solution'>A</div>
                </div>
              </div>
            </div>
          HTML
        )
      )
    end

    it 'doesn\'t double-bake exercises' do
      book_with_nested_examples.examples.each do |example|
        described_class.v1(example: example, number: 5, title_tag: 'h5')
      end
      expect(book_with_nested_examples.pages.first).to match_normalized_html(
        <<~HTML
          <div data-type="page">
            <div data-type="example" id="example-test">
              <h5 class="os-title">
                <span class="os-title-label">Example </span>
                <span class="os-number">5</span>
                <span class="os-divider"> </span>
              </h5>
              <div class="body">
                <div data-type="example" id="example-test2">
                  <h5 class="os-title">
                    <span class="os-title-label">Example </span>
                    <span class="os-number">5</span>
                    <span class="os-divider"> </span>
                  </h5>
                  <div class="body">
                    <div class="unnumbered" data-type="exercise">
                      <div data-type="problem">
                        <div class="os-problem-container">Q</div>
                      </div>
                      <div data-type="solution">
                        <h4 data-type="solution-title">
                          <span class="os-title-label">Solution </span>
                        </h4>
                        <div class="os-solution-container">A</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when book does not use grammatical cases' do
    it 'stores link text' do
      pantry = example.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Example 4', { label: 'example-test' })
      described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
    end
  end

  context 'when book uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'example': {
            'nominative': 'Przykład',
            'genitive': 'Przykładu'
          }
        })

        pantry = example.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Przykład 4', { label: 'example-test' })

        pantry = example.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Przykładu 4', { label: 'example-test' })
        described_class.v1(example: example, number: 4, title_tag: 'title-tag-name', cases: true)
      end
    end
  end

  describe 'ExampleElement#titles_to_rename' do
    let(:example) do
      book_containing(html:
        <<~HTML
          <div data-type="chapter">
            <div data-type="page">
              <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
              <div data-type='example' id='example-test'>
                <span data-type="title" id="title1">example title becomes h4</span>
                <div data-type="exercise">
                  <span data-type="title" id="title2">exercise title is skipped</span>
                </div>
                <div data-type="note">
                  <h3 data-type="title" id="title3">note title is skipped</h3>
                </div>
                <table><caption><span data-type="title" id="title4">unbaked table title is skipped</span></caption></table>
                <div class="os-table">
                  <table></table>
                  <div class="os-caption-container">
                    <span data-type="title" id="title5">baked table title (V1) is skipped</span>
                  </div>
                </div>
                <div class="os-table">
                  <table></table>
                  <div class="os-caption-container">
                    <div class="os-caption">
                      <span data-type="title" id="title6">baked table title (V2) is skipped</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        HTML
      ).examples.first
    end

    it 'skips titles within tables & notes' do
      renamed_title_ids = example.titles_to_rename.map { |title| title.id }
      expect(renamed_title_ids).to eq(%w[title1])
    end
  end
end
