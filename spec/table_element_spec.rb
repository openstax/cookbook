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

  let(:titled_table) { book_with_titled_table.tables.first }

  it 'gets the title' do
    expect(titled_table.title.text).to eq 'The Title'
  end
end
