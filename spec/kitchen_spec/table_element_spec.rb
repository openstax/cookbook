# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::TableElement do
  let(:book_with_titled_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="top-titled" id="tableId" summary="A long summary...">
            <thead>
              <tr>
                <th colspan="1" data-align="center">The Title</th>
              </tr>
              <tr valign="top">
                <th data-align="left">Heading</th>
              </tr>
            </thead>
            <tbody>
              <tr valign="top">
                <td data-align="left">Bar</td>
              </tr>
            </tbody>
          </table>
        HTML
      )
    )
  end

  let(:book_with_top_captioned_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="top-captioned" id="tableId" summary="A long summary...">
          <caption><span data-type='title'>Top Caption Title</span></caption>
            <thead>
              <tr valign="top">
                <th data-align="left">Heading</th>
              </tr>
            </thead>
            <tbody>
              <tr valign="top">
                <td data-align="left">Bar</td>
              </tr>
            </tbody>
          </table>
        HTML
      )
    )
  end

  let(:book_with_tables) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="unnumbered" id="tableId" summary="A summary...">
            <caption>A caption<span data-type='title'>Secret Title</span></caption>
            <thead>
              <tr>
                <th colspan="1" data-align="center">The Title</th>
              </tr>
              <tr valign="top">
                <th data-align="left">Heading</th>
              </tr>
              <tr valign="top">
                <th colspan="2" data-align="left">Heading</th>
              </tr>
            </thead>
            <tbody>
              <tr valign="top">
                <td data-align="left">Bar</td>
              </tr>
            </tbody>
          </table>
          <pre data-type="code" class="python line-numbering" data-lang="python">
            <table class="hljs-ln">
              <tr>
                <td class="hljs-ln-line hljs-ln-numbers" data-line-number="1">
                  <div class="hljs-ln-n" data-line-number="1">1</div>
                </td>
                <td class="hljs-ln-line hljs-ln-code" data-line-number="1">
                  <span class="hljs-comment"># Setup a list of numbers</span>
                </td>
              </tr>
              <tr>
                <td class="hljs-ln-line hljs-ln-numbers" data-line-number="2">
                  <div class="hljs-ln-n" data-line-number="2">2</div>
                </td>
                <td class="hljs-ln-line hljs-ln-code" data-line-number="2">
                  num_list = [<span class="hljs-number">2</span>, <span class="hljs-number">3</span>]
                </td>
              </tr>
            </table>
          </pre>
          <table id="tableId" summary="A long summary...">
            <caption><span data-type='title'>Caption Title</span></caption>
            <thead>
              <tr valign="top">
                <th data-align="left">Heading</th>
              </tr>
            </thead>
            <tbody>
              <tr valign="top">
                <td data-align="left">Bar</td>
              </tr>
            </tbody>
          </table>
        HTML
      )
    )
  end

  let(:titled_table) { book_with_titled_table.tables.first }
  let(:top_captioned_table) { book_with_top_captioned_table.tables.first }

  it 'gets the title' do
    expect(titled_table.title.text).to eq 'The Title'
  end

  it 'gets the caption title' do
    expect(top_captioned_table.caption_title.text).to eq 'Top Caption Title'
  end

  describe '#table_to_number?' do
    it 'can select what tables should be baked and counted' do
      expect(book_with_tables.tables.map(&:table_to_number?)).to eq([false, false, true])
    end
  end
end
