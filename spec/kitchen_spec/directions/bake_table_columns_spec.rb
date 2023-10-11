# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeTableColumns do

  let(:book1) do
    book_containing(html:
      <<~HTML
        <table id="tableId" summary="A summary...">
          <colgroup>
            <col data-width="1*"/>
            <col data-width="2*"/>
          </colgroup>
          <thead>
            <tr>
              <th colspan="2" data-align="center">The Title</th>
            </tr>
            <tr valign="top">
              <th data-align="left">Heading</th>
              <th data-align="left">Headin2</th>
            </tr>
          </thead>
          <tbody>
            <tr valign="top">
              <td data-align="left">Bar</td>
              <td data-align="left">Foo</td>
            </tr>
          </tbody>
        </table>
      HTML
    )
  end

  let(:one_column_table) do
    book_containing(html:
      <<~HTML
        <table id="tableId" summary="A summary...">
          <colgroup>
            <col data-width="1*"/>
          </colgroup>
          <thead>
            <tr>
              <th data-align="center">The Title</th>
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

  let(:multiple_columns_table) do
    book_containing(html:
      <<~HTML
        <table id="tableId" summary="A summary...">
          <colgroup>
            <col data-width="1*"/>
            <col data-width="2*"/>
            <col data-width="1*"/>
          </colgroup>
          <thead>
            <tr>
              <th colspan="3" data-align="center">The Title</th>
            </tr>
            <tr valign="top">
              <th data-align="left">Heading</th>
              <th data-align="left">Heading2</th>
              <th data-align="left">Heading3</th>
            </tr>
          </thead>
          <tbody>
            <tr valign="top">
              <td data-align="left">Bar</td>
              <td data-align="left">Foo</td>
              <td data-align="left">Some</td>
            </tr>
          </tbody>
        </table>
      HTML
    )
  end

  it 'bakes table columns' do
    described_class.v1(book: book1)
    expect(book1.body.children.to_s).to match_snapshot_auto
  end

  it 'does not bake table with one column' do
    described_class.v1(book: one_column_table)
    expect(one_column_table.body.children.to_s).to match_snapshot_auto
  end

  it 'bakes table with multiple columns' do
    described_class.v1(book: multiple_columns_table)
    expect(multiple_columns_table.body.children.to_s).to match_snapshot_auto
  end
end
