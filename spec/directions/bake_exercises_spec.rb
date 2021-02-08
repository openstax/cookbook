# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExercises do

  before do
    stub_locales({
      eoc_exercises_title: 'Exercises',
      eoc_answer_key_title: 'Answer Key',
      chapter: 'Chapter'
    })
  end

  let(:book1) do
    book_containing(html:
      <<~HTML
        #{metadata(title: 'Book Title')}
        <div data-type="chapter">
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Chapter 1 Title</h1>
            <span data-type="binding" data-value="translucent"></span>
          </div>
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div data-type="page" id="m68760" class="introduction" data-cnxml-to-html-ver="1.7.3"></div>
          <div data-type="page" id="m68761" data-cnxml-to-html-ver="1.7.3">
            #{metadata(title: 'Page 1 Title')}
            <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
            <section data-depth="1" id="auto_m68761_fs-idp29893056" class="exercises">
              <h3 data-type="title">Chemistry End of Chapter Exercises</h3>
              <div data-type="exercise" id="auto_m68761_fs-idp113763312">
                <div data-type="problem" id="auto_m68761_fs-idp26515120">
                  <p id="auto_m68761_fs-idm51965232">Problem 1</p>
                </div>
                <div data-type="solution" id="auto_m68761_fs-idp28518832">
                  <p id="auto_m68761_fs-idp139010576">Solution 1</p>
                </div>
              </div>
              <div data-type="exercise" id="auto_m68761_fs-idp56789136">
                <div data-type="problem" id="auto_m68761_fs-idm24701936">
                  <p id="auto_m68761_fs-idp57923840">Problem 2</p>
                </div>
              </div>
              <div data-type="exercise" id="auto_m68761_fs-idm25346224">
                <div data-type="problem" id="auto_m68761_fs-idp29743712">
                  <p id="auto_m68761_fs-idm23990224">Problem 3</p>
                </div>
                <div data-type="solution" id="auto_m68761_fs-idm71693776">
                  <p id="auto_m68761_fs-idm7102688">Solution 3</p>
                </div>
              </div>
            </section>
          </div>
          <div data-type="page" id="m68764" data-cnxml-to-html-ver="1.7.3">
            #{metadata(title: 'Page 2 Title')}
            <div data-type="document-title" id="auto_m68764_28725">Page 2 Title</div>
            <section data-depth="1" id="auto_m68764_fs-idm81325184" class="exercises">
              <h3 data-type="title">Chemistry End of Chapter Exercises</h3>
              <div data-type="exercise" id="auto_m68764_fs-idm178529488">
                <div data-type="problem" id="auto_m68764_fs-idp20517968">
                  <p id="auto_m68764_fs-idm197064800">Problem 4</p>
                </div>
              </div>
              <div data-type="exercise" id="auto_m68764_fs-idm82765632">
                <div data-type="problem" id="auto_m68764_fs-idp7685184">
                  <p id="auto_m68764_fs-idm164104512">Problem 5</p>
                </div>
                <div data-type="solution" id="auto_m68764_fs-idm128797504">
                  <p id="auto_m68764_fs-idm152759136">Solution 5</p>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(book: book1)

    expect(book1.body).to match_normalized_html(
      <<~HTML
        <body>
          #{metadata(title: 'Book Title')}
          <div data-type="chapter">
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Chapter 1 Title</h1>
              <span data-type="binding" data-value="translucent"></span>
            </div>
            <h1 data-type="document-title">Chapter 1 Title</h1>
            <div data-type="page" id="m68760" class="introduction" data-cnxml-to-html-ver="1.7.3"></div>
            <div data-type="page" id="m68761" data-cnxml-to-html-ver="1.7.3">
              #{metadata(title: 'Page 1 Title')}
              <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
            </div>
            <div data-type="page" id="m68764" data-cnxml-to-html-ver="1.7.3">
              #{metadata(title: 'Page 2 Title')}
              <div data-type="document-title" id="auto_m68764_28725">Page 2 Title</div>
            </div>
            <div class="os-eoc os-exercises-container" data-type="composite-page" data-uuid-key=".exercises">
              <h2 data-type="document-title">
                <span class="os-text">Exercises</span>
              </h2>
              #{metadata(title: 'Exercises', id_suffix: '_copy_1')}
              <section data-depth="1" id="auto_m68761_fs-idp29893056" class="exercises">
                <a href="#auto_m68761_72010">
                  <h3 data-type="document-title" id="auto_m68761_72010_copy_1">
                    <span class="os-number">1.1</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Page 1 Title</span>
                  </h3>
                </a>
                <div data-type="exercise" id="auto_m68761_fs-idp113763312" class="os-hasSolution">
                  <div data-type="problem" id="auto_m68761_fs-idp26515120">
                    <a class="os-number" href="#auto_m68761_fs-idp113763312-solution">1</a>
                    <span class="os-divider">. </span>
                    <div class="os-problem-container ">
                      <p id="auto_m68761_fs-idm51965232">Problem 1</p>
                    </div>
                  </div>
                </div>
                <div data-type="exercise" id="auto_m68761_fs-idp56789136">
                  <div data-type="problem" id="auto_m68761_fs-idm24701936">
                    <span class="os-number">2</span>
                    <span class="os-divider">. </span>
                    <div class="os-problem-container ">
                      <p id="auto_m68761_fs-idp57923840">Problem 2</p>
                    </div>
                  </div>
                </div>
                <div data-type="exercise" id="auto_m68761_fs-idm25346224" class="os-hasSolution">
                  <div data-type="problem" id="auto_m68761_fs-idp29743712">
                    <a class="os-number" href="#auto_m68761_fs-idm25346224-solution">3</a>
                    <span class="os-divider">. </span>
                    <div class="os-problem-container ">
                      <p id="auto_m68761_fs-idm23990224">Problem 3</p>
                    </div>
                  </div>
                </div>
              </section>
              <section data-depth="1" id="auto_m68764_fs-idm81325184" class="exercises">
                <a href="#auto_m68764_28725">
                  <h3 data-type="document-title" id="auto_m68764_28725_copy_1">
                    <span class="os-number">1.2</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Page 2 Title</span>
                  </h3>
                </a>
                <div data-type="exercise" id="auto_m68764_fs-idm178529488">
                  <div data-type="problem" id="auto_m68764_fs-idp20517968">
                    <span class="os-number">4</span>
                    <span class="os-divider">. </span>
                    <div class="os-problem-container ">
                      <p id="auto_m68764_fs-idm197064800">Problem 4</p>
                    </div>
                  </div>
                </div>
                <div data-type="exercise" id="auto_m68764_fs-idm82765632" class="os-hasSolution">
                  <div data-type="problem" id="auto_m68764_fs-idp7685184">
                    <a class="os-number" href="#auto_m68764_fs-idm82765632-solution">5</a>
                    <span class="os-divider">. </span>
                    <div class="os-problem-container ">
                      <p id="auto_m68764_fs-idm164104512">Problem 5</p>
                    </div>
                  </div>
                </div>
              </section>
            </div>
          </div>
          <div class="os-eob os-solution-container " data-type="composite-chapter" data-uuid-key=".solution">
            <h1 data-type="document-title" id="composite-chapter-1">
              <span class="os-text">Answer Key</span>
            </h1>
            #{metadata(title: 'Answer Key', id_suffix: '_copy_2')}
            <div class="os-eob os-solution-container " data-type="composite-page" data-uuid-key=".solution1">
              <h2 data-type="document-title">
                <span class="os-text">Chapter 1</span>
              </h2>
              #{metadata(title: 'Chapter 1', id_suffix: '_copy_3')}
              <div data-type="solution" id="auto_m68761_fs-idp113763312-solution">
                <a class="os-number" href="#auto_m68761_fs-idp113763312">1</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container ">
                  <p id="auto_m68761_fs-idp139010576">Solution 1</p>
                </div>
              </div>
              <div data-type="solution" id="auto_m68761_fs-idm25346224-solution">
                <a class="os-number" href="#auto_m68761_fs-idm25346224">3</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container ">
                  <p id="auto_m68761_fs-idm7102688">Solution 3</p>
                </div>
              </div>
              <div data-type="solution" id="auto_m68764_fs-idm82765632-solution">
                <a class="os-number" href="#auto_m68764_fs-idm82765632">5</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container ">
                  <p id="auto_m68764_fs-idm152759136">Solution 5</p>
                </div>
              </div>
            </div>
          </div>
        </body>
      HTML
    )
  end

  describe '#bake_exercise_in_place' do
    let(:exercise) do
      book_containing(html:
        one_chapter_with_one_page_containing(
          <<~HTML
            <div data-type="exercise" id="exerciseId">
              <div data-type="problem" id="problemId">
                <p>Problem Content</p>
              </div>
              #{solution}
            </div>
          HTML
      )).chapters.search('#exerciseId').first
    end

    context 'with a solution' do
      let(:solution) do
        <<~HTML
          <div data-type="solution" id="solutionId">
            <p>Solution Content</p>
          </div>
        HTML
      end

      it 'works' do
        described_class.bake_exercise_in_place(exercise: exercise)

        expect(exercise).to match_html_nodes(
          <<~HTML
            <div data-type="exercise" id="exerciseId" class="os-hasSolution">
              <div data-type="problem" id="problemId">
                <a class="os-number" href="#exerciseId-solution">1</a>
                <span class="os-divider">. </span>
                <div class="os-problem-container ">
                  <p>Problem Content</p>
                </div>
              </div>
              <div data-type="solution" id="exerciseId-solution">
                <a class="os-number" href="#exerciseId">1</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container ">
                  <p>Solution Content</p>
                </div>
              </div>
            </div>
          HTML
        )
      end
    end

    context 'without a solution' do
      let(:solution) { '' }

      it 'works' do
        described_class.bake_exercise_in_place(exercise: exercise)

        expect(exercise).to match_html_nodes(
          <<~HTML
            <div data-type="exercise" id="exerciseId">
              <div data-type="problem" id="problemId">
                <span class="os-number">1</a>
                <span class="os-divider">. </span>
                <div class="os-problem-container ">
                  <p>Problem Content</p>
                </div>
              </div>
            </div>
          HTML
        )
      end
    end
  end

  def metadata(title:, id_suffix: '')
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <h1 data-type="document-title" itemprop="name">#{title}</h1>
        <div class="authors">
          <span id="author-1#{id_suffix}" ><a>OpenStaxCollege</a></span>
        </div>
        <div class="publishers">
          <span id="publisher-1#{id_suffix}"><a>OpenStaxCollege</a></span>
        </div>
        <div class="print-style">
          <span data-type="print-style">ccap-chemistry</span>
        </div>
        <div class="permissions">
          <p class="copyright">
            <span id="copyright-holder-1#{id_suffix}"><a>OSCRiceUniversity</a></span>
          </p>
          <p class="license">
            <a>CC BY</a>
          </p>
        </div>
        <div itemprop="about" data-type="subject">Science and Technology</div>
      </div>
    HTML
  end
end
