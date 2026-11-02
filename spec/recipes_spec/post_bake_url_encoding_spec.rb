# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'post-bake URL encoding' do
  let(:html) do
    <<~'HTML'
      <span data-type="slug" data-value="post-bake-test" />
      <p><a id="existing" href='https://example.org/?existing=%2F&amp;query=a=b#{"issue_id":390208,"page":0}'>Existing link</a></p>
      <p id="generated">https://example.org/{café}?q=one%20two&amp;x=1.</p>
      <a id="empty" href="https://example.org/100%" />
      <p id="email">name@example.org</p>
      <p id="quoted">See 'https://example.org/path' for more.</p>
    HTML
  end

  before do
    document = book_containing(html: html, short_name: :post_bake).document
    POST_BAKE.document = document
    POST_BAKE.bake
  end

  let(:document) { POST_BAKE.document.raw }

  it 'encodes unsafe characters while preserving query delimiters and existing escapes' do
    expect(document.at_xpath('//*[@id="existing"]')['href']).to eq(
      'https://example.org/?existing=%2F&query=a=b#%7B%22issue_id%22:390208,%22page%22:0%7D'
    )
  end

  it 'encodes newly linked Unicode and braces while preserving query syntax' do
    expect(document.at_xpath('//*[@id="generated"]/a')['href']).to eq(
      'https://example.org/%7Bcaf%C3%A9%7D?q=one%20two&x=1'
    )
  end

  it 'encodes malformed percent signs in anchors with no text' do
    expect(document.at_xpath('//*[@id="empty"]')['href']).to eq('https://example.org/100%25')
  end

  it 'preserves email links and excludes a trailing apostrophe from a plain-text URL' do
    expect(document.at_xpath('//*[@id="email"]/a')['href']).to eq('mailto:name@example.org')
    expect(document.at_xpath('//*[@id="quoted"]/a')['href']).to eq('https://example.org/path')
    expect(document.at_xpath('//*[@id="quoted"]').text).to eq("See 'https://example.org/path' for more.")
  end
end
