require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterKeyEquations do
  let(:chapter) do
    chapter_element(
      <<~HTML
        <section class="key-equations">
          <h3>WWF History</h3>
          <p>Equations blah.</p>
        </section>
      HTML
    )
  end

  it 'works' do
    expect(
      described_class.v1(chapter: chapter, metadata_source: metadata_element)
    ).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div class="os-eoc os-key-equations-container" data-type="composite-page" data-uuid-key=".key-equations">
            <h2 data-type="document-title">
              <span class="os-text">Key Equations</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Key Equations</h1>
              <div class="authors" id="authors_copy_1">Authors</div><div class="publishers" id="publishers_copy_1">Publishers</div><div class="print-style" id="print-style_copy_1">Print Style</div><div class="permissions" id="permissions_copy_1">Permissions</div><div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <section class="key-equations">
              <p>Equations blah.</p>
            </section>
          </div>
        </div>
      HTML
    )
  end
end
