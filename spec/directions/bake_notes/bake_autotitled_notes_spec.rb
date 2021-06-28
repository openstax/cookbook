# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAutotitledNotes do
  let(:book_with_notes) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId" class="foo">
            <p>content</p>
          </div>
          <div data-type="note" id="noteId" class="baz">
            <div data-type="title" id="titleId">note <em data-effect="italics">title</em></div>
            <p>content</p>
          </div>
          <div data-type="note" id="untitlednote" class="123">
            <p>content</p>
            <div data-type="note" id="untitlednote" class="foo">
              <p>this is a nested note</p>
            </div>
          </div>

          <div data-type="note" class="project" id='parent-note-1'>
            <div data-type="title">Resonance</div>
            <p>Consider an undamped system exhibiting...</p>
            <ol>
              <li>Consider the differential equation</li>
              <li>Graph the solution. What happens to the behavior of the system over time?</li>
              <li>
                In the real world... <span data-type="term" class="no-emphasis">Tacoma Narrows Bridge</span>
                <div data-type="note" class="media-2" id='child-note-1'>
                  <p>blah</p>
                </div>
                <div data-type="note" class="media-2" id='child-note-2'>
                  <p><a href="http://www.openstax.org/l/20_TacomaNarro2">video</a> blah</p>
                </div>
              </li>
              <li>
                Another real-world example of resonance is a singer...
                <div data-type="note" class="media-2" id='child-note-3'>
                  <p>video</p>
                </div>
              </li>
            </ol>
          </div>
        HTML
      )
    )
  end

  before do
    stub_locales({
      'notes': {
        'foo': 'Bar',
        'baz': 'Baaa',
        'project': 'Project',
        'media-2': 'Media'
      }
    })
  end

  it 'bakes' do
    described_class.v1(book: book_with_notes, classes: %w[foo baz project media-2])
    expect(book_with_notes.body.pages.first).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <div class="foo" data-type="note" id="noteId">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Bar</span>
            </h3>
            <div class="os-note-body">
              <p>content</p>
            </div>
          </div>
          <div class="baz" data-type="note" id="noteId">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Baaa</span>
            </h3>
            <div class="os-note-body">
              <h4 class="os-subtitle" data-type="title" id="titleId">
                <span class="os-subtitle-label">note <em data-effect="italics">title</em></span>
              </h4>
              <p>content</p>
            </div>
          </div>
          <div data-type="note" id="untitlednote" class="123">
            <p>content</p>
            <div class="foo" data-type="note" id="untitlednote">
              <h3 class="os-title" data-type="title">
                <span class="os-title-label">Bar</span>
              </h3>
              <div class="os-note-body">
                <p>this is a nested note</p>
              </div>
            </div>
          </div>
          <div class="project" data-type="note" id="parent-note-1">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Project</span>
            </h3>
            <div class="os-note-body">
              <h4 class="os-subtitle" data-type="title">
                <span class="os-subtitle-label">Resonance</span>
              </h4>
              <p>Consider an undamped system exhibiting...</p>
              <ol>
                <li>Consider the differential equation</li>
                <li>Graph the solution. What happens to the behavior of the system over time?</li>
                <li>
              In the real world... <span class="no-emphasis" data-type="term">Tacoma Narrows Bridge</span>
              <div class="media-2" data-type="note" id="child-note-1"><h3 class="os-title" data-type="title"><span class="os-title-label">Media</span></h3><div class="os-note-body"><p>blah</p></div></div>
              <div class="media-2" data-type="note" id="child-note-2"><h3 class="os-title" data-type="title"><span class="os-title-label">Media</span></h3><div class="os-note-body"><p><a href="http://www.openstax.org/l/20_TacomaNarro2">video</a> blah</p></div></div>
            </li>
                <li>
              Another real-world example of resonance is a singer...
              <div class="media-2" data-type="note" id="child-note-3"><h3 class="os-title" data-type="title"><span class="os-title-label">Media</span></h3><div class="os-note-body"><p>video</p></div></div>
            </li>
              </ol>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
