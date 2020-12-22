require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedTable::V1 do

  before do
    stub_locales({
      'table_label': 'Table'
    })
  end

  let(:caption) { '<caption>A caption</caption>' }

  let(:table) do
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

  it 'works' do
    described_class.new.bake(table: table, number: '2.3')

    expect(table.document.search('.os-table').first).to match_normalized_html(
      <<~HTML
        <div class="os-table">
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

  context 'no caption' do
    let(:caption) { '' }

    it 'does not include an os-caption div' do
      described_class.new.bake(table: table, number: '2.3')
      expect(table.document).not_to match('os-caption')
    end
  end

end
