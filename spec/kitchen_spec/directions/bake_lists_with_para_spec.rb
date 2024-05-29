# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeListsWithPara do

  let(:book) do
    book_containing(html:
      <<~HTML
        <ol>
          <li>
            <p>blah1</p>
          </li>
          <li>
            <p>blah2</p>
          </li>
          <li>
            <p><span>random term</span> blah3</p>
          </li>
          <li>
            <p>blah3</p>
            <figure id="someId">
              <span data-type="media" id="otherId" data-alt="This figure shows pieces of a ...">
                <img src="blah.jpg" data-media-type="image/jpeg" alt="This figure shows ..." id="id3" />
              </span>
            </figure>
          </li>
          <li>
            <p>blah4</p>
            <ol>
              <li>
                <p>blah5</p>
              </li>
              <li>
                <p>blah6<a href="#aside1" role="doc-noteref">[footnote]</a></p>
                <aside id="aside1" type="footnote">Footnote content 1</aside>
              </li>
            </ol>
          </li>
        </ol>
        <ul>
          <li>
            <p>foo1</p>
          </li>
          <li>
            <p>foo2</p>
          </li>
          <li>
            <p><span>random term2</span> foo3</p>
          </li>
          <li>
            <p>foo3</p>
            <figure id="someId2">
              <span data-type="media" id="otherId2" data-alt="This figure shows pieces of a ...">
                <img src="foo.jpg" data-media-type="image/jpeg" alt="This figure shows ..." id="id4" />
              </span>
            </figure>
          </li>
        </ul>
      HTML
    )
  end

  it 'works' do
    described_class.v1(book: book)
    expect(book.body).to match_snapshot_auto
  end

end
