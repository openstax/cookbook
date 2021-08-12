# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedTable::V2 do
  let(:table_with_only_caption_title) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="some-class" id="tId">
            <caption><span data-type='title'>Secret Title</span></caption>
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

  let(:top_captioned_table) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <table class="top-captioned">
            <caption><span data-type='title'>Top Caption Title</span></caption>
            <thead>
              <tr>
                <th>Heading cell</th>
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

  it 'another way of table captioning' do
    described_class.new.bake(table: table_with_only_caption_title, number: 'S')
    expect(table_with_only_caption_title.document.search('.os-table').first).to match_normalized_html(
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
            <span class="os-number">S</span>
            <span class="os-divider"> </span>
            <span class="os-caption">
              <span data-type="title">Secret Title</span>
            </span>
          </div>
        </div>
      HTML
    )
  end

  it 'bakes a top-captioned table' do
    described_class.new.bake(table: top_captioned_table, number: '2.3')

    expect(top_captioned_table.document.search('.os-table').first).to match_normalized_html(
      <<~HTML
        <div class="os-table os-top-captioned-container">
          <div class="os-top-caption">Top Caption Title</div>
          <table class="top-captioned">
            <thead>
              <tr>
                <th>Heading cell</th>
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
          </div>
        </div>
      HTML
    )
  end

end
