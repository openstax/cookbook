# frozen_string_literal: true

require 'benchmark'
require 'spec_helper'

RSpec.describe 'post-bake URL encoding' do
  let(:html) do
    <<~'HTML'
      <span data-type="slug" data-value="post-bake-test" />
      <p><a id="existing" href='https://example.org/?existing=%2F&amp;query=a=b#{"issue_id":390208,"page":0}'>Existing link</a></p>
      <p id="generated">https://example.org/{café}?q=one%20two&amp;x=1.</p>
      <a id="empty" href="https://example.org/100%" />
      <p id="email">name@example.org</p>
      <p id="email-in-url">https://name@example.org/path</p>
      <p id="quoted">See 'https://example.org/path' for more.</p>
      <p id="uppercase">Http://example.org/path</p>
      <p id="www">www.google.com</p>
      <p id="invalid-www">www..google.com</p>
      <p id="invalid-www-label">www.-google.com</p>
      <p id="punycode-domain">www.xn--p1ai</p>
      <p id="bare-domain">google.com</p>
      <p id="bare-domain-path">example.org/search?q=one&amp;x=2</p>
      <p id="ftp">ftp://google.com/path</p>
      <p id="ftp-email">ftp://name@example.org/path</p>
      <p id="domain-suffix">google.com123</p>
      <p id="identifier-prefix">value_google.com</p>
      <p id="identifier-suffix">google.com_extra</p>
      <p id="unicode-domain">münich.de</p>
      <p id="unicode-identifier">value_münich.de</p>
      <p id="method-identifiers">file.read h.update h.hexdigest m.in et.al</p>
      <p id="code-sample"><code>google.com</code></p>
      <pre id="code-block">file.read(1024) h.update(chunk) h.hexdigest()</pre>
      <p id="empty-host">https:///www.bls.gov</p>
      <p id="punctuation-host">https://.?x</p>
      <p id="encoded-punctuation-host">https://%2E/?x=1</p>
      <p id="bare-example">https://.?</p>
      <p id="curly-quote">http://.”</p>
      <p id="truncated-percent">https://example.org/#:~:text=In%</p>
      <p id="javascript">javascript:alert(1)</p>
      <p id="dash-in-path">https://example.org/2010–2019</p>
      <p id="dash-after-host">See https://example.org—and more</p>
      <p id="dash-trailing">https://example.org/path—</p>
      <p id="dash-after-port">https://example.org:8080–2025</p>
      <p id="dash-before-domain">See—example.org</p>
      <p id="dash-two-urls">https://example.org—https://other.org</p>
      <p id="dash-prose-after-path">https://example.org/path—read more</p>
      <p id="dash-non-range-in-path">https://example.org/a–b</p>
      <p id="root-path">example.it/</p>
      <p id="word-like-www">www.example.it</p>
      <p id="word-like-path">example.it/page</p>
      <p id="word-like-caps">ezAUTO.MY</p>
      <p id="word-like-lowercase">relevant.it</p>
      <p id="word-like-capitalized">relevant.It</p>
      <p id="balanced-parens">(https://en.wikipedia.org/wiki/Foo_(bar)).</p>
      <p id="embedded-paren">See(https://example.org/path).</p>
      <p id="embedded-paren-host">See(https://example.org).</p>
      <p id="idn-bare">Dyżurnet.pl</p>
      <p id="math"><math xmlns="http://www.w3.org/1998/Math/MathML"><mtext>example.org</mtext></math></p>
    HTML
  end
  let(:document) { POST_BAKE.document.raw }

  before do
    document = book_containing(html: html, short_name: :post_bake).document
    POST_BAKE.document = document
    POST_BAKE.bake
  end

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
    expect(document.at_xpath('//*[@id="email-in-url"]/a')['href']).to eq('https://name@example.org/path')
    expect(document.at_xpath('//*[@id="quoted"]/a')['href']).to eq('https://example.org/path')
    expect(document.at_xpath('//*[@id="quoted"]').text).to eq("See 'https://example.org/path' for more.")
  end

  it 'accepts case-insensitive HTTP schemes' do
    expect(document.at_xpath('//*[@id="uppercase"]/a')['href']).to eq('Http://example.org/path')
  end

  it 'adds HTTPS to valid www candidates' do
    expect(document.at_xpath('//*[@id="www"]/a')['href']).to eq('https://www.google.com')
    expect(document.at_xpath('//*[@id="punycode-domain"]/a')['href']).to eq('https://www.xn--p1ai')
  end

  it 'adds HTTPS to valid domains without www' do
    expect(document.at_xpath('//*[@id="bare-domain"]/a')['href']).to eq('https://google.com')
    expect(document.at_xpath('//*[@id="bare-domain-path"]/a')['href']).to eq(
      'https://example.org/search?q=one&x=2'
    )
  end

  it 'converts internationalized domains to IDNA ASCII hosts' do
    expect(document.at_xpath('//*[@id="unicode-domain"]/a')['href']).to eq('https://xn--mnich-kva.de')
  end

  plain_text_cases = {
    'invalid-www' => 'www..google.com',
    'invalid-www-label' => 'www.-google.com',
    'domain-suffix' => 'google.com123',
    'ftp' => 'ftp://google.com/path',
    'ftp-email' => 'ftp://name@example.org/path',
    'empty-host' => 'https:///www.bls.gov',
    'identifier-prefix' => 'value_google.com',
    'identifier-suffix' => 'google.com_extra',
    'unicode-identifier' => 'value_münich.de',
    'method-identifiers' => 'file.read h.update h.hexdigest m.in et.al',
    'punctuation-host' => 'https://.?x',
    'encoded-punctuation-host' => 'https://%2E/?x=1',
    'bare-example' => 'https://.?',
    'curly-quote' => 'http://.”',
    'truncated-percent' => 'https://example.org/#:~:text=In%',
    'javascript' => 'javascript:alert(1)',
    'word-like-lowercase' => 'relevant.it',
    'word-like-capitalized' => 'relevant.It'
  }

  plain_text_cases.each do |id, text|
    it "leaves #{id} as plain text" do
      expect(document.at_xpath("//*[@id='#{id}']/a")).to be_nil
      expect(document.at_xpath("//*[@id='#{id}']").text).to eq(text)
    end
  end

  it 'does not link inside inline code' do
    expect(document.at_xpath('//*[@id="code-sample"]/code/a')).to be_nil
    expect(document.at_xpath('//*[@id="code-sample"]/code').text).to eq('google.com')
  end

  it 'does not link inside code blocks' do
    expect(document.at_xpath('//*[@id="code-block"]/a')).to be_nil
    expect(document.at_xpath('//*[@id="code-block"]').text).to eq(
      'file.read(1024) h.update(chunk) h.hexdigest()'
    )
  end

  it 'does not link inside math' do
    expect(document.at_xpath('//*[@id="math"]//a')).to be_nil
  end

  it 'keeps en/em dashes inside paths' do
    link = document.at_xpath('//*[@id="dash-in-path"]/a')
    expect(link['href']).to eq('https://example.org/2010%E2%80%932019')
    expect(link.text).to eq('https://example.org/2010–2019')
  end

  it 'ends the URL at a dash after the host' do
    expect(document.at_xpath('//*[@id="dash-after-host"]/a')['href']).to eq('https://example.org')
    expect(document.at_xpath('//*[@id="dash-after-host"]').text).to eq('See https://example.org—and more')
    expect(document.at_xpath('//*[@id="dash-after-port"]/a')['href']).to eq('https://example.org:8080')
  end

  it 'excludes a trailing dash from the URL' do
    expect(document.at_xpath('//*[@id="dash-trailing"]/a')['href']).to eq('https://example.org/path')
  end

  it 'ends the URL at a prose dash in the path' do
    link = document.at_xpath('//*[@id="dash-prose-after-path"]/a')
    expect(link['href']).to eq('https://example.org/path')
    expect(document.at_xpath('//*[@id="dash-prose-after-path"]').text).to eq(
      'https://example.org/path—read more'
    )
    expect(document.at_xpath('//*[@id="dash-non-range-in-path"]/a')['href']).to eq('https://example.org/a')
  end

  it 'links text after a dash' do
    expect(document.at_xpath('//*[@id="dash-before-domain"]/a')['href']).to eq('https://example.org')
    expect(document.xpath('//*[@id="dash-two-urls"]/a').map { |a| a['href'] }).to eq(
      ['https://example.org', 'https://other.org']
    )
  end

  it 'links word-like TLDs only with www, a path (including a bare "/"), or all caps' do
    expect(document.at_xpath('//*[@id="root-path"]/a')['href']).to eq('https://example.it/')
    expect(document.at_xpath('//*[@id="word-like-www"]/a')['href']).to eq('https://www.example.it')
    expect(document.at_xpath('//*[@id="word-like-path"]/a')['href']).to eq('https://example.it/page')
    expect(document.at_xpath('//*[@id="word-like-caps"]/a')['href']).to eq('https://ezAUTO.MY')
  end

  it 'keeps closing brackets that balance an opener inside the URL' do
    link = document.at_xpath('//*[@id="balanced-parens"]/a')
    expect(link['href']).to eq('https://en.wikipedia.org/wiki/Foo_(bar)')
    expect(document.at_xpath('//*[@id="balanced-parens"]').text).to eq(
      '(https://en.wikipedia.org/wiki/Foo_(bar)).'
    )
  end

  it 'does not count brackets before an embedded scheme as part of the URL' do
    expect(document.at_xpath('//*[@id="embedded-paren"]/a')['href']).to eq('https://example.org/path')
    expect(document.at_xpath('//*[@id="embedded-paren"]').text).to eq('See(https://example.org/path).')
    expect(document.at_xpath('//*[@id="embedded-paren-host"]/a')['href']).to eq('https://example.org')
  end

  it 'marks internationalized bare links as bare even though the href is punycode' do
    link = document.at_xpath('//*[@id="idn-bare"]/a')
    expect(link['href']).to eq('https://xn--dyurnet-xwb.pl')
    expect(link['data-bare-link']).to eq('true')
  end

  describe 'pathological text' do
    it 'balances a long run of brackets in linear time' do
      url = "https://example.org/#{'(' * 20_000}#{')' * 20_000}"
      document = book_containing(html: "<p id=\"p\">#{url}</p>", short_name: :post_bake).document
      POST_BAKE.document = document

      elapsed = Benchmark.realtime { POST_BAKE.bake }

      expect(elapsed).to be < 2
      expect(POST_BAKE.document.raw.at_xpath('//*[@id="p"]/a').text).to eq(url)
    end

    # Before the link patterns were bounded, each of these took several seconds (or far
    # longer, at larger sizes) because the regex rescanned the whole run from every position.
    {
      'dotted run' => 'a.' * 20_000,
      'hyphenated run' => 'a-' * 20_000,
      'dotted run with trailing text' => "#{'a.' * 20_000}!",
      'at-sign run' => 'a@' * 20_000,
      'email-like run' => "x@#{'y.' * 20_000}",
      'dash run' => "x.#{'—' * 20_000}",
      'dash-separated run' => "x.#{'—x.' * 20_000}",
      'en dash range run' => "x.org/#{'1–' * 20_000}1",
      'overlong label' => "#{'a' * 100}.com",
      'overlong local part' => "#{'a' * 100}@example.org"
    }.each do |name, text|
      it "links nothing and finishes quickly for a #{name}" do
        document = book_containing(html: "<p id=\"p\">#{text}</p>", short_name: :post_bake).document
        POST_BAKE.document = document

        elapsed = Benchmark.realtime { POST_BAKE.bake }

        expect(elapsed).to be < 2
        expect(POST_BAKE.document.raw.at_xpath('//*[@id="p"]/a')).to be_nil
        expect(POST_BAKE.document.raw.at_xpath('//*[@id="p"]').text).to eq(text)
      end
    end
  end
end
