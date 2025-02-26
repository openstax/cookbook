# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeImages do
  let(:book_pages) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <img src="../resources/abcdef" data-media-type="image/jpeg" alt="an image" data-sm="blah"/>
          <img src="../resources/123456" data-media-type="image/jpeg" alt="an image" data-sm="blah2" width="241"/>
          <img src="../resources/xyzqrs" data-media-type="image/jpeg" alt="an image" data-sm="blah3" height="90"/>
        HTML
      )
    ).pages
  end

  let(:resources) do
    {
      "abcdef": { "original_name": 'test_02_09_001.jpg', "mime_type": 'image/jpeg', "s3_md5": '"xyz789"', "sha1": 'abcdef', "width": 1028, "height": 464 },
      "123456": { "original_name": 'test_02_09_002.jpg', "mime_type": 'image/jpeg', "s3_md5": '"xyz789"', "sha1": '123456', "width": 482, "height": 222 },
      "xyzqrs": { "original_name": 'test_02_09_003.jpg', "mime_type": 'image/jpeg', "s3_md5": '"xyz789"', "sha1": '123456', "width": 100, "height": 181 }
    }
  end

  it 'works' do
    described_class.v1(book_pages: book_pages, resources: resources)
    expect(book_pages.first).to match_normalized_html(
      <<~HTML
        <div data-type="page" id="testidOne">
          <img src="../resources/abcdef" data-media-type="image/jpeg" alt="an image" data-sm="blah" width="1028" height="464"/>
          <img src="../resources/123456" data-media-type="image/jpeg" alt="an image" data-sm="blah2" width="241" height="111"/>
          <img src="../resources/xyzqrs" data-media-type="image/jpeg" alt="an image" data-sm="blah3" width="49" height="90"/>
        </div>
      HTML
    )
  end

  it 'logs warning' do
    expect(Warning).to receive(:warn).with(/Could not find resource for image/, { category: nil }).exactly(3).times
    described_class.v1(book_pages: book_pages, resources: nil)
  end

end
