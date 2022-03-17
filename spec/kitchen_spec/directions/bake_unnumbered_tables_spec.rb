# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeUnnumberedTables do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <table class="unnumbered unstyled" id="tableId" summary="A summary...">
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

  let(:book_with_column_header_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="unnumbered column-header" id="tId" summary="column header summary">
          </table>
        HTML
      )
    )
  end

  let(:book_with_top_titled_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="unnumbered top-titled" id="tId" summary="column header summary">
          </table>
        HTML
      )
    )
  end

  it 'bakes unstyled table' do
    described_class.v1(book: book1)
    expect(
      book1.body.children.to_s
    ).to match_snapshot_auto
  end

  it 'bakes column header table' do
    described_class.v1(book: book_with_column_header_table)
    expect(book_with_column_header_table.tables.first.parent).to match_snapshot_auto
  end

  it 'bakes top-titled table' do
    described_class.v1(book: book_with_top_titled_table)
    expect(book_with_top_titled_table.tables.first.parent).to match_snapshot_auto
  end
end
