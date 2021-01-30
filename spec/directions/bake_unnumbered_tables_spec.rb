# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeUnnumberedTables do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <table class="unnumbered top-titled" id="tableId" summary="A summary...">
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
  end

  it 'works' do
    described_class.v1(book: book1)
    expect(
      book1.body.children.to_s
    ).to match_normalized_html(
      <<~HTML
        <div class="os-table">
          <table class="unnumbered top-titled" id="tableId">
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
        </div>
      HTML
    )
  end
end
