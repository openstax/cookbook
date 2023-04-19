# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedTable::V1 do

  before do
    stub_locales({
      'table': 'Table'
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
                <th scope="col">A title</th>
              </tr>
              <tr>
                <th scope="col">Another heading cell</th>
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

  let(:text_heavy_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="text-heavy" id="tId">
          </table>
        HTML
      )
    ).tables.first
  end

  let(:unstyled_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="unstyled" id="tId">
          </table>
        HTML
      )
    ).tables.first
  end

  let(:text_heavy_top_titled_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="text-heavy top-titled" id="tId">
            <thead><tr>test</tr></thead>
          </table>
        HTML
      )
    ).tables.first
  end

  let(:timeline_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="timeline-table" id="tId">
          </table>
        HTML
      )
    ).tables.first
  end

  let(:data_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="data-table" id="tId">
          </table>
        HTML
      )
    ).tables.first
  end

  let(:narrow_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="narrow-table" id="tId">
          </table>
        HTML
      )
    ).tables.first
  end

  let(:vertically_tight_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="vertically-tight" id="tId">
          </table>
        HTML
      )
    ).tables.first
  end

  let(:no_cellborder_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="no-cellborder" id="tId">
          </table>
        HTML
      )
    ).tables.first
  end

  let(:full_width_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="full-width" id="tId">
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
                <th scope="col">A title</th>
              </tr>
              <tr>
                <th scope="col">Another heading cell</th>
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
                <th scope="col">A title</th>
              </tr>
              <tr>
                <th scope="col">Another heading cell</th>
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

    expect(top_titled_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes a column header table' do
    described_class.new.bake(table: column_header_table, number: '2.3')

    expect(column_header_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes a text heavy table' do
    described_class.new.bake(table: text_heavy_table, number: '2.3')

    expect(text_heavy_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes an unstyled table' do
    described_class.new.bake(table: unstyled_table, number: '2.3')

    expect(unstyled_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes a text heavy top titled table' do
    described_class.new.bake(table: text_heavy_top_titled_table, number: '2.3')

    expect(text_heavy_top_titled_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes a timeline table' do
    described_class.new.bake(table: timeline_table, number: '2.3')

    expect(timeline_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes a data table' do
    described_class.new.bake(table: data_table, number: '2.3')

    expect(data_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes a narrow table' do
    described_class.new.bake(table: narrow_table, number: '2.3')

    expect(narrow_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes a vertically-tight table' do
    described_class.new.bake(table: vertically_tight_table, number: '2.3')

    expect(vertically_tight_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes a no-cellborder table' do
    described_class.new.bake(table: no_cellborder_table, number: '2.3')

    expect(no_cellborder_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes a full width table' do
    described_class.new.bake(table: full_width_table, number: '2.3')

    expect(full_width_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes another kind of table' do
    described_class.new.bake(table: other_table, number: '2.3')

    expect(other_table.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes another table with a caption title' do
    described_class.new.bake(table: table_with_caption_title, number: '2.3')

    expect(table_with_caption_title.document.search('.os-table').first).to match_snapshot_auto
  end

  it 'bakes another table with a caption on top' do
    described_class.new.bake(table: table_with_caption_title, number: '2.3', move_caption_on_top: true)

    expect(table_with_caption_title.document.search('.os-table').first).to match_snapshot_auto
  end

  context 'when no caption' do
    let(:caption) { '' }

    it 'does not include an os-caption' do
      described_class.new.bake(table: top_titled_table, number: '2.3')
      expect(top_titled_table.document).not_to match('os-caption')
    end
  end

  context 'when blank caption' do
    let(:caption) { "\n     \n    " }

    it 'does not include an os-caption' do
      described_class.new.bake(table: top_titled_table, number: '2.3')
      expect(top_titled_table.document).not_to match('os-caption')
    end
  end

  context 'when book does not use grammatical cases' do
    it 'stores link text' do
      pantry = other_table.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Table 2.3', { label: 'tId' })
      described_class.new.bake(table: other_table, number: '2.3')
    end
  end

  context 'when book uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'table': {
            'nominative': 'Tabela',
            'genitive': 'Tabeli'
          }
        })

        pantry = other_table.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Tabela 2.3', { label: 'tId' })

        pantry = other_table.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Tabeli 2.3', { label: 'tId' })
        described_class.new.bake(table: other_table, number: '2.3', cases: true)
      end
    end
  end

  context 'when link to table has class' do
    it 'stores link class' do
      pantry = other_table.pantry(name: :link_type)
      expect(pantry).to receive(:store).with('table-target-label', { label: 'tId' })
      described_class.new.bake(table: other_table, number: '2.3', label_class: 'table-target-label')
    end
  end
end
