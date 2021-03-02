# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedTable::V1 do

  before do
    stub_locales({
      'table_label': 'Table'
    })
  end

  let(:caption) { '<caption>A caption</caption>' }

  let(:top_titled_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="top-titled" id="tId" summary="Some summary">
            #{caption}
            <thead>
              <tr>
                <th>A title</th>
              </tr>
              <tr>
                <th>Another heading cell</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>One lonely cell</td>
              </tr>
            </tbody>
          </table>
        HTML
      )
    ).tables.first
  end

  let(:column_header_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="column-header" id="tId" summary="column header summary">
          </table>
        HTML
      )
    ).tables.first
  end

  let(:other_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="some-class" id="tId" summary="Some summary">
            #{caption}
            <thead>
              <tr>
                <th>A title</th>
              </tr>
              <tr>
                <th>Another heading cell</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>One lonely cell</td>
              </tr>
            </tbody>
          </table>
        HTML
      )
    ).tables.first
  end

  it 'bakes a top-titled table' do
    described_class.new.bake(table: top_titled_table, number: '2.3')

    expect(top_titled_table.document.search('.os-table').first).to match_normalized_html(
      <<~HTML
        <div class="os-table os-top-titled-container">
          <div class="os-table-title">A title</div>
          <table class="top-titled" id="tId" summary="Table 2.3  A caption">
            <thead>
              <tr>
                <th>Another heading cell</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>One lonely cell</td>
              </tr>
            </tbody>
          </table>
          <div class="os-caption-container">
            <span class="os-title-label">Table </span>
            <span class="os-number">2.3</span>
            <span class="os-divider"> </span>
            <span class="os-divider"> </span>
            <span class="os-caption">A caption</span>
          </div>
        </div>
      HTML
    )
  end

  it 'bakes a column header table' do
    described_class.new.bake(table: column_header_table, number: '2.3')

    expect(column_header_table.document.search('.os-table').first).to match_normalized_html(
      <<~HTML
        <div class="os-table os-column-header-container">
          <table class="column-header" id="tId" summary="Table 2.3  ">
        </table>
          <div class="os-caption-container">
            <span class="os-title-label">Table </span>
            <span class="os-number">2.3</span>
            <span class="os-divider"> </span>
            <span class="os-divider"> </span>
          </div>
        </div>
      HTML
    )
  end

  it 'bakes another kind of table' do
    described_class.new.bake(table: other_table, number: '2.3')

    expect(other_table.document.search('.os-table').first).to match_normalized_html(
      <<~HTML
        <div class="os-table">
          <table class="some-class" id="tId" summary="Table 2.3  A caption">
            <thead>
              <tr>
                <th>A title</th>
              </tr>
              <tr>
                <th>Another heading cell</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>One lonely cell</td>
              </tr>
            </tbody>
          </table>
          <div class="os-caption-container">
            <span class="os-title-label">Table </span>
            <span class="os-number">2.3</span>
            <span class="os-divider"> </span>
            <span class="os-divider"> </span>
            <span class="os-caption">A caption</span>
          </div>
        </div>
      HTML
    )
  end

  context 'when no caption' do
    let(:caption) { '' }

    it 'does not include an os-caption div' do
      described_class.new.bake(table: top_titled_table, number: '2.3')
      expect(top_titled_table.document).not_to match('os-caption')
    end
  end

end
