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

          <div class="interactive" data-has-label="true" data-label="" data-type="note" id="iframenote">
            <div data-alt="atoms_isotopes" data-type="media">
              <iframe height="371.4" src="https://openstax.org/l/atoms_isotopes" width="660"><!-- no-selfclose -->
              </iframe>
            </div>
          </div>
          <div class="interactive" data-has-label="true" data-label="" data-type="note" id="iframenote">
            <div data-alt="atoms_isotopes" data-type="media">
              <iframe height="371.4" width="660"><!-- no-selfclose -->
              </iframe>
            </div>
          </div>
          <div class="interactive interactive-long" data-has-label="true" data-label="" data-type="note" id="iframenote3">
            <ul>
              <li>1: The evolution from fish to earliest tetrapod<span data-type="newline"><br /></span>
                <div data-alt="tetrapod_evol1" data-type="media"><iframe height="371.4" src="url1" width="660"><!-- no-selfclose --></iframe></div>
              </li>
              <li>2: The discovery of coelacanth and <em data-effect="italics">Acanthostega</em> fossils<span data-type="newline"><br /></span>
                <div data-alt="tetrapod_evol2" data-type="media"><iframe height="371.4" src="url2" width="660"><!-- no-selfclose --></iframe></div>
              </li>
            </ul>
          </div>
        HTML
      )
    )
  end

  before do
    stub_locales({
      'iframe_link_text': 'Click to view content',
      'notes': {
        'foo': 'Bar',
        'baz': 'Baaa',
        'project': 'Project',
        'media-2': 'Media',
        'interactive': 'Link to Learning'
      }
    })
  end

  it 'bakes' do
    described_class.v1(book: book_with_notes, classes: %w[foo baz project media-2 interactive])
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
          <div class="interactive" data-has-label="true" data-label="" data-type="note" id="iframenote">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Link to Learning</span>
            </h3>
            <div class="os-note-body">
              <div data-alt="atoms_isotopes" data-type="media">
                <div class="os-has-iframe os-has-link" data-type="alternatives"><a class="os-is-link" href="https://openstax.org/l/atoms_isotopes" target="_window">Click to view content</a>
                  <iframe class="os-is-iframe" height="371.4" src="https://openstax.org/l/atoms_isotopes" width="660"><!-- no-selfclose -->
                  </iframe>
                </div>
              </div>
            </div>
          </div>
          <div class="interactive" data-has-label="true" data-label="" data-type="note" id="iframenote">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Link to Learning</span>
            </h3>
            <div class="os-note-body">
              <div data-alt="atoms_isotopes" data-type="media">
                <div class="os-has-iframe" data-type="alternatives">
                  <iframe class="os-is-iframe" height="371.4" width="660">
        <!-- no-selfclose -->
                  </iframe>
                </div>
              </div>
            </div>
          </div>
          <div class="interactive interactive-long" data-has-label="true" data-label="" data-type="note" id="iframenote3">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Link to Learning</span>
            </h3>
            <div class="os-note-body">
              <ul>
                <li>1: The evolution from fish to earliest tetrapod<span data-type="newline"><br /></span>
              <div data-alt="tetrapod_evol1" data-type="media">
                <div class="os-has-iframe os-has-link" data-type="alternatives"><a class="os-is-link" href="url1" target="_window">Click to view content</a>
                  <iframe class="os-is-iframe" height="371.4" src="url1" width="660"><!-- no-selfclose -->
                  </iframe>
                </div>
              </div>
            </li>
                <li>2: The discovery of coelacanth and <em data-effect="italics">Acanthostega</em> fossils<span data-type="newline"><br /></span>
              <div data-alt="tetrapod_evol2" data-type="media">
                <div class="os-has-iframe os-has-link" data-type="alternatives"><a class="os-is-link" href="url2" target="_window">Click to view content</a>
                  <iframe class="os-is-iframe" height="371.4" src="url2" width="660"><!-- no-selfclose -->
                  </iframe>
                </div>
              </div>
            </li>
              </ul>
            </div>
          </div>
        </div>
      HTML
    )
  end

  context 'when book does not use grammatical cases' do
    it 'stores link text' do
      pantry = book_with_notes.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Resonance', { label: 'parent-note-1' })
      expect(pantry).to receive(:store).with('note <em data-effect="italics">title</em>', { label: 'noteId' })
      described_class.v1(book: book_with_notes, classes: %w[foo baz project media-2 interactive])
    end
  end

  context 'when book uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'note': {
            'nominative': 'Ramka',
            'genitive': 'Ramki'
          }
        })

        pantry = book_with_notes.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Ramka Resonance', { label: 'parent-note-1' })
        expect(pantry).to receive(:store).with('Ramka note <em data-effect="italics">title</em>', { label: 'noteId' })

        pantry = book_with_notes.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Ramki Resonance', { label: 'parent-note-1' })
        expect(pantry).to receive(:store).with('Ramki note <em data-effect="italics">title</em>', { label: 'noteId' })
        described_class.v1(book: book_with_notes, classes: %w[foo baz project media-2 interactive], cases: true)
      end
    end
  end
end
