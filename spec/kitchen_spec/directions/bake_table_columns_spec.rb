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

  it 'bakes table columns' do
    described_class.v1(book: book1)
    expect(book1.body.children.to_s).to match_snapshot_auto
  end
end
