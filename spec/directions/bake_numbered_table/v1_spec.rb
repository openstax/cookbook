# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedTable::V1 do

  before do
    stub_locales({
      'table_label': 'Table'
    })
  end

  let(:caption) { '<caption>A caption</caption>' }
  let(:caption_with_title) { "<caption>A caption<span data-type='title'>Secret Title</span></caption>" }

  let(:top_titled_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="top-titled">
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
          <table class="column-header" id="tId">
          </table>
        HTML
      )
    ).tables.first
  end

  let(:other_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="some-class" id="tId">
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

  let(:table_with_caption_title) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="some-class" id="tId">
            #{caption_with_title}
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
          <table class="top-titled">
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
    described_class.new.bake(table: column_header_table, number: '2.3', always_caption: false)

    expect(column_header_table.document.search('.os-table').first).to match_normalized_html(
      <<~HTML
        <div class="os-table os-column-header-container">
          <table class="column-header" id="tId">
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
          <table class="some-class" id="tId">
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

  it 'bakes another table with a caption title' do
    described_class.new.bake(table: table_with_caption_title, number: '2.3', always_caption: true)

    expect(table_with_caption_title.document.search('.os-table').first).to match_normalized_html(
      <<~HTML
        <div class="os-table">
          <table class="some-class" id="tId">
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
            <span class="os-title" data-type="title">Secret Title</span>
            <span class="os-divider"> </span>
            <span class="os-caption">A caption</span>
          </div>
        </div>
      HTML
    )
  end

  context 'when no caption and always_caption false' do
    let(:caption) { '' }

    it 'does not include an os-caption' do
      described_class.new.bake(table: top_titled_table, number: '2.3')
      expect(top_titled_table.document).not_to match('os-caption')
    end
  end

  context 'when no caption and always_caption true' do
    let(:caption) { '' }

    it 'does include an os-caption' do
      described_class.new.bake(table: column_header_table, number: '2.3', always_caption: true)
      expect(column_header_table.document.search('.os-table').first).to match_normalized_html(
        <<~HTML
          <div class="os-table os-column-header-container">
            <table class="column-header" id="tId">
          </table>
            <div class="os-caption-container">
              <span class="os-title-label">Table </span>
              <span class="os-number">2.3</span>
              <span class="os-divider"> </span>
              <span class="os-divider"> </span>
              <span class="os-caption"></span>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when blank caption and always_caption false' do
    let(:caption) { "\n     \n    " }

    it 'does not include an os-caption' do
      described_class.new.bake(table: top_titled_table, number: '2.3')
      expect(top_titled_table.document).not_to match('os-caption')
    end
  end

  context 'when blank caption and always_caption true' do
    let(:caption) { " \n    \n " }

    it 'does include an os-caption' do
      described_class.new.bake(table: column_header_table, number: '2.3', always_caption: true)
      expect(column_header_table.document.search('.os-table').first).to match_normalized_html(
        <<~HTML
          <div class="os-table os-column-header-container">
            <table class="column-header" id="tId">
          </table>
            <div class="os-caption-container">
              <span class="os-title-label">Table </span>
              <span class="os-number">2.3</span>
              <span class="os-divider"> </span>
              <span class="os-divider"> </span>
              <span class="os-caption"></span>
            </div>
          </div>
        HTML
      )
    end
  end

end
