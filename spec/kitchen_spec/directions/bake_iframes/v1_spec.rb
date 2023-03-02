# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIframes::V1 do
  let(:book_with_iframes_in_note_and_list) do
    book_containing(html:
      <<~HTML
        <span data-type="slug" data-value="the-book-slug">
        <div data-type="chapter">
          <div data-type="page" class="introduction"></div>
          <div data-type="page" id="page_1234">
            <h1 data-type="document-title">The Document: Title!</h1>
            <div class="interactive" data-has-label="true" data-label="" data-type="note" id="iframenote">
              <div data-alt="atoms_isotopes" data-type="media" id="media1">
                <iframe height="371.4" src="https://openstax.org/l/atoms_isotopes" width="660"><!-- no-selfclose -->
                  </iframe>
              </div>
            </div>
            <div class="interactive interactive-long" data-has-label="true" data-label="" data-type="note" id="iframenote3">
              <ul>
                <li>1: The evolution from fish to earliest tetrapod<span data-type="newline"><br /></span>
                  <div data-alt="tetrapod_evol1" data-type="media" id="media2"><iframe height="371.4" src="url1" width="660"><!-- no-selfclose --></iframe></div>
                </li>
                <li>2: The discovery of coelacanth and <em data-effect="italics">Acanthostega</em> fossils<span data-type="newline"><br /></span>
                  <div data-alt="tetrapod_evol2" data-type="media" id="media3"><iframe height="371.4" src="url2" width="660"><!-- no-selfclose --></iframe></div>
                </li>
              </ul>
            </div>
          </div>
        </div>
      HTML
    )
  end

  let(:book_with_baked_iframes) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><div data-type="page" id="page_4567">
          <div class="os-has-iframe os-has-link" data-type="alternatives"><a class="os-is-link" href="abc">Click to view content</a>
            <iframe height="371.4" src="abc" width="660" class="os-is-iframe">
          <!-- no-selfclose -->
            </iframe>
          </div>
        </div></div>
      HTML
    )
  end

  before do
    stub_locales({
      'iframe_link_text': 'Click to view content'
    })
  end

  it 'bakes iframes' do
    described_class.new.bake(book: book_with_iframes_in_note_and_list)
    expect(book_with_iframes_in_note_and_list.search('div.interactive[data-type="note"]').to_s).to match_snapshot_auto
  end

  it 'doesn\'t double-bake' do
    book_with_baked_iframes_snapshot = book_with_baked_iframes.copy
    described_class.new.bake(book: book_with_baked_iframes)
    expect(book_with_baked_iframes).to match_normalized_html(book_with_baked_iframes_snapshot)
  end

  context 'with exceptions' do
    let(:book_with_iframe_no_slug) do
      book_containing(html:
        <<~HTML
          <div data-type="chapter">
            <div data-type="page" class="introduction"></div>
            <div data-type="page" id="page_1234">
              <h1 data-type="document-title">The Document: Title!</h1>
              <div data-alt="atoms_isotopes" data-type="media" id="1234">
                <iframe height="371.4" src="https://openstax.org/l/atoms_isotopes" width="660"><!-- no-selfclose -->
                  </iframe>
              </div>
            </div>
          </div>
        HTML
      )
    end

    let(:book_with_iframe_no_id_on_media) do
      book_containing(html:
        <<~HTML
          <span data-type="slug" data-value="the-book-slug">
          <div data-type="chapter">
            <div data-type="page" class="introduction"></div>
            <div data-type="page" id="page_1234">
              <h1 data-type="document-title">The Document: Title!</h1>
              <div data-alt="atoms_isotopes" data-type="media">
                <iframe height="371.4" src="https://openstax.org/l/atoms_isotopes" width="660"><!-- no-selfclose -->
                  </iframe>
              </div>
            </div>
          </div>
        HTML
      )
    end

    it 'warns when rex link can\'t be made - no slug' do
      expect(Warning).to receive(:warn).with(
        /Unable to find rex link for iframe with parent[^>]+id="1234"/
      )
      described_class.new.bake(book: book_with_iframe_no_slug)
    end
  end
end
