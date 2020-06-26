require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExercises do

  before do
    stub_locales({
      'exercises': 'Exercises'
    })
  end

  let(:book_1) do
    book_containing(html:
      <<~HTML
        <div data-type="metadata" style="display: none;">
          <h1 data-type="document-title" itemprop="name">Book Title</h1>
          <div class="authors">
            <span id="author-1" ><a>OpenStaxCollege</a></span>
          </div>
          <div class="publishers">
            <span id="publisher-1"><a>OpenStaxCollege</a></span>
          </div>
          <div class="print-style">
            <span data-type="print-style">ccap-chemistry</span>
          </div>
          <div class="permissions">
            <p class="copyright">
              <span id="copyright-holder-1"><a>OSCRiceUniversity</a></span>
            </p>
            <p class="license">
              <a>CC BY</a>
            </p>
          </div>
          <div itemprop="about" data-type="subject">Science and Technology</div>
        </div>
        <div data-type="chapter">
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Chapter 1 Title</h1>
            <span data-type="binding" data-value="translucent"></span>
          </div>
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div data-type="page" id="m68760" class="introduction" data-cnxml-to-html-ver="1.7.3">
          </div>
          <div data-type="page" id="m68761" data-cnxml-to-html-ver="1.7.3">
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Page 1 Title</h1>
              <div class="authors">
                <span id="author-1"><a>OpenStaxCollege</a></span>
              </div>
              <div class="publishers">
                <span id="publisher-1"><a>OpenStaxCollege</a></span>
              </div>
              <div class="permissions">
                <p class="copyright">
                  <span id="copyright-holder-1"><a>OSCRiceUniversity</a></span>
                </p>
                <p class="license">
                  <a>CC BY</a>
                </p>
              </div>
            </div>
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
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Page 1 Title</h1>
            </div>
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

  it "works" do
    described_class.v1(book: book_1)

    expect(book_1.elements("body").elements("*").to_s).to match_html(
      <<~HTML
      <div data-type="metadata" style="display: none;">
        <h1 data-type="document-title" itemprop="name">Book Title</h1>
        <div class="authors">
          <span id="author-1" ><a>OpenStaxCollege</a></span>
        </div>
        <div class="publishers">
          <span id="publisher-1"><a>OpenStaxCollege</a></span>
        </div>
        <div class="print-style">
          <span data-type="print-style">ccap-chemistry</span>
        </div>
        <div class="permissions">
          <p class="copyright">
            <span id="copyright-holder-1"><a>OSCRiceUniversity</a></span>
          </p>
          <p class="license">
            <a>CC BY</a>
          </p>
        </div>
        <div itemprop="about" data-type="subject">Science and Technology</div>
      </div>
      <div data-type="chapter">
        <div data-type="metadata" style="display: none;">
          <h1 data-type="document-title" itemprop="name">Chapter 1 Title</h1>
          <span data-type="binding" data-value="translucent"></span>
        </div>
        <h1 data-type="document-title">Chapter 1 Title</h1>
        <div data-type="page" id="m68760" class="introduction" data-cnxml-to-html-ver="1.7.3">
        </div>
        <div data-type="page" id="m68761" data-cnxml-to-html-ver="1.7.3">
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Page 1 Title</h1>
            <div class="authors">
              <span id="author-1"><a>OpenStaxCollege</a></span>
            </div>
            <div class="publishers">
              <span id="publisher-1"><a>OpenStaxCollege</a>
            </div>
            <div class="permissions">
              <p class="copyright">
                <span id="copyright-holder-1"><a>OSCRiceUniversity</a></span>
              </p>
              <p class="license">
                <a>CC BY</a>
              </p>
            </div>
          </div>
          <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
        </div>
        <div data-type="page" id="m68764" data-cnxml-to-html-ver="1.7.3">
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Page 1 Title</h1>
          </div>
          <div data-type="document-title" id="auto_m68764_28725">Page 2 Title</div>
        </div>
        <div class="os-eoc os-exercises-container" data-type="composite-page" data-uuid-key=".exercises">
          <h2 data-type="document-title">
            <span class="os-text">Exercises</span>
          </h2>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Exercises</h1>
            <div class="authors">
              <span id="author-1" ><a>OpenStaxCollege</a></span>
            </div>
            <div class="publishers">
              <span id="publisher-1"><a>OpenStaxCollege</a></span>
            <div class="print-style">
              <span data-type="print-style">ccap-chemistry</span>
            </div>
            <div class="permissions">
              <p class="copyright">
                <span id="copyright-holder-1"><a>OSCRiceUniversity</a></span>
              </p>
              <p class="license">
                <a>CC BY</a>
              </p>
            </div>
            <div itemprop="about" data-type="subject">Science and Technology</div>
          </div>
          <section data-depth="1" id="auto_m68761_fs-idp29893056" class="exercises">
            <a href="#auto_m68761_72010">
              <h3 data-type="document-title" id="auto_m68761_72010">Page 1 Title</h3>
            </a>
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
          <section data-depth="1" id="auto_m68764_fs-idm81325184" class="exercises">
            <a href="#auto_m68764_28725">
              <h3 data-type="document-title" id="auto_m68764_28725">Page 2 Title</h3>
            </a>
            <div data-type="exercise" id="auto_m68764_fs-idm178529488">
              <div data-type="problem" id="auto_m68764_fs-idp20517968">
                <p id="auto_m68764_fs-idm197064800">Problem 4</p>
              </div>
            </div>
            <div data-type="exercise" id="auto_m68764_fs-idm82765632">
              <div data-type="problem" id="auto_m68764_fs-idp7685184">
                <p id="auto_m68764_fs-idm164104512">Problem 5</span></p>
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
end
