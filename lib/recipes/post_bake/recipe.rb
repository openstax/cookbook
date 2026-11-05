# frozen_string_literal: true

require 'uri'
require 'addressable/uri'

# Link detection is a two-step process: a deliberately dumb tokenizer splits text on whitespace
# and markup delimiters (linear time, no lookarounds), then each token is classified and validated
# in plain Ruby (see link_href_for). Keep the regexes below simple; put the rules in code.
TOKEN_PATTERN = /([^[:space:]<>"\u2013\u2014\u2026]+)/ # [[:space:]] also covers U+00A0; en/em dash and ellipsis end a token
LEADING_PUNCTUATION = /\A[(\[{'\u201C\u2018]+/
TRAILING_PUNCTUATION = /[.,;:!?)\]'}\u201D\u2019]+\z/
CLOSING_PAIRS = { ')' => '(', ']' => '[', '}' => '{' }.freeze
SOFT_HYPHEN = "\u00AD"
HTTP_URL_PREFIX = /\Ahttps?:\/\//i
EMAIL_CANDIDATE_PATTERN = /\A[A-Za-z0-9._%+-]{1,64}@[A-Za-z0-9.-]{1,255}\.[A-Za-z]{2,63}\z/
QUICK_CHECK = /:\/\/|www|@|[\p{L}\d]\.[\p{L}\d]/ # Fast check before tokenizing
# Elements whose text must never be linkified (the whole subtree is skipped): existing links,
# code-like text, non-HTML content (math, svg), non-rendered text, and interactive content
# (an <a> inside these is invalid).
LINK_IGNORE = %w[
  a dt dd code pre kbd samp tt var
  math svg script style textarea title head template noscript
  button summary label option select
].freeze
IGNORED_NAMESPACES = %w[
  http://www.w3.org/1998/Math/MathML
  http://www.w3.org/2000/svg
].freeze
# Keep bare-domain linking conservative to avoid treating dotted words as hostnames.
COMMON_TLDS = %w[
  ai app ar at au be br ca ch cn co com cloud cz de dev dk edu es eu fi gov gr hk hu
  id ie il in int io it jp kr la ly me mil mx my name net nl no nz online org ph pl pro pt ru
  se sg site tech th tr tv tw uk us vn xyz za xn--p1ai biz info
].freeze
# TLDs that are also common English words or file extensions ("relevant.it"). A bare
# domain with one of these needs a www. prefix or a path/query/fragment/port to be linked.
WORD_LIKE_TLDS = %w[at be id in int it la me my no pro name online site us].freeze
# Keep URL delimiters intact; encode invalid percent signs and unsafe bytes.
URL_UNSAFE_CHARACTERS = /%(?![0-9A-Fa-f]{2})|[^A-Za-z0-9\-._~:\/?#\[\]@!$&'()*+,;=%]/

def percent_encode_url(url)
  url.gsub(URL_UNSAFE_CHARACTERS) do |character|
    character.bytes.map { |byte| format('%%%02X', byte) }.join
  end
end

def normalized_http_url(url)
  # Reject malformed escapes before the encoder could normalize them.
  return if url.match?(/%(?![0-9A-Fa-f]{2})/)

  uri = Addressable::URI.parse(url)
  return unless %w[http https].include?(uri.scheme&.downcase)

  host = uri.host.to_s
  return if host.empty?

  unless host.start_with?('[') && host.end_with?(']')
    host = URI::DEFAULT_PARSER.unescape(host).unicode_normalize(:nfc)
    return unless valid_domain_name?(host)

    # Convert Unicode host labels to ASCII IDNA form, using Punycode where needed.
    uri.host = Addressable::IDNA.to_ascii(host)
  end

  normalized_url = uri.to_s
  strict_uri = URI.parse(percent_encode_url(normalized_url))
  normalized_url if http_uri_with_host?(strict_uri)
rescue Addressable::URI::InvalidURIError, Addressable::IDNA::PunycodeBadInput,
       Addressable::IDNA::PunycodeBigOutput, Addressable::IDNA::PunycodeOverflow, URI::Error
  nil
end

def valid_domain_name?(host)
  host = host.delete_suffix('.')
  return false if host.empty? || host.bytesize > 253

  host.split('.', -1).all? do |label|
    label.match?(/\A[\p{L}\p{N}](?:[\p{L}\p{M}\p{N}-]*[\p{L}\p{N}])?\z/)
  end
end

def valid_bare_domain_candidate?(candidate)
  # Everything before the first path/query/fragment/port delimiter must be a valid hostname.
  return false unless valid_domain_name?(candidate[/\A[^\/?#:]+/].to_s)

  uri = Addressable::URI.parse("https://#{candidate}")
  host = uri.host.to_s
  return false if host.empty?

  host = URI::DEFAULT_PARSER.unescape(host).unicode_normalize(:nfc)
  ascii_host = Addressable::IDNA.to_ascii(host)
  labels = ascii_host.delete_suffix('.').split('.')
  return false if labels.length < 2 || labels[-2].length < 2

  tld = labels.last
  return false unless COMMON_TLDS.include?(tld.downcase)
  return true unless WORD_LIKE_TLDS.include?(tld.downcase)

  # Word-like TLDs: "relevant.It" (capitalized, a missing space after a period) is never a link,
  # ALL-CAPS ("ezAUTO.MY") is, and lowercase needs a www. prefix or a path/port ("relevant.it" is not).
  return false if tld.match?(/\A\p{Lu}\p{Ll}+\z/)
  return true if tld == tld.upcase

  labels.first == 'www' || candidate.match?(/\A[^\/?#:]+(?:[\/?#].|:\d)/)
rescue Addressable::URI::InvalidURIError, Addressable::IDNA::PunycodeBadInput,
       Addressable::IDNA::PunycodeBigOutput, Addressable::IDNA::PunycodeOverflow, URI::Error
  false
end

def http_uri_with_host?(uri)
  return false unless %w[http https].include?(uri.scheme&.downcase)

  host = uri.host.to_s
  return false if host.empty?
  return true if host.start_with?('[') && host.end_with?(']')

  host = URI::DEFAULT_PARSER.unescape(host)
  return false unless host.ascii_only?

  host = host.delete_suffix('.')
  return false if host.empty? || host.bytesize > 253

  labels = host.split('.', -1)

  labels.all? do |label|
    label.bytesize <= 63 && label.match?(/\A[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\z/)
  end
end

def link_ignored?(element)
  return false unless element.element?

  LINK_IGNORE.include?(element.name) ||
    IGNORED_NAMESPACES.include?(element.namespace&.href) ||
    element.key?('data-math')
end

def convert_textual_links(element)
  # 1. Prune the search: If we are in an ignored element, stop recursing.
  return if link_ignored?(element)

  # We use .children.to_a because we will be modifying the collection
  # while iterating, and we don't want to break the iterator.
  element.children.to_a.each do |child|
    if child.text?
      # 2. Quick Check: Don't run the complex regex if there's no '.' or '://'
      next unless child.content =~ QUICK_CHECK

      linkify_text_node(child)
    elsif child.element?
      convert_textual_links(child)
    end
  end
end

# "(234).https://x.org" and "text,https://x.org": peel off whatever precedes an embedded http(s)
# scheme. Letters glued to the scheme ("Publishinghttps://...") are deliberately left as text.
def split_embedded_scheme(candidate)
  index = candidate.index('://')
  return ['', candidate] unless index

  scheme = candidate[0...index][/[A-Za-z0-9+.-]*\z/].to_s.sub(/\A[^A-Za-z]+/, '')
  return ['', candidate] unless scheme.match?(/\Ahttps?\z/i)

  start = index - scheme.length
  [candidate[0...start], candidate[start..]]
end

# For a bare domain, link the longest run of hostname characters; anything after it (a closing
# paren, quote, zero-width space...) stays plain text unless it starts a port/path/query/fragment.
HOST_RUN = /\A[\p{L}\p{M}\p{N}.-]+/
def bare_domain_link_text(candidate)
  host = candidate[HOST_RUN].to_s.sub(/\.+\z/, '')
  return unless host.include?('.')

  rest = candidate[host.length..].to_s
  return if rest.sub(/\A\.+/, '').match?(/\A[_+@]/)

  text = rest.match?(/\A[\/?#:]/) ? candidate : host
  text if valid_bare_domain_candidate?(text)
end

# Returns [href, extra_attributes, link_text] for a trimmed token, or nil to leave it as text.
def link_href_for(candidate)
  if EMAIL_CANDIDATE_PATTERN.match?(candidate)
    ["mailto:#{candidate}",
     { 'aria-label': I18n.t(:email_link_desc, email: candidate), 'data-bare-link': 'true' },
     candidate]
  elsif HTTP_URL_PREFIX.match?(candidate)
    # A soft hyphen is a line-break hint: keep it in the visible text, not in the href.
    href = normalized_http_url(candidate.delete(SOFT_HYPHEN))
    [href, {}, candidate] if href
  elsif (text = bare_domain_link_text(candidate)) # also rejects mailto:, ftp:, "Note:this"
    href = normalized_http_url("https://#{text}")
    [href, {}, text] if href
  end
end

# Splits trailing punctuation off a token, but keeps a closing ) ] } that balances an opener
# inside the URL, e.g. "https://en.wikipedia.org/wiki/Foo_(bar)." -> [".../Foo_(bar)", "."].
def split_trailing_punctuation(token)
  trailing = token[TRAILING_PUNCTUATION].to_s
  body = token.delete_suffix(trailing)
  kept = 0
  trailing.each_char do |char|
    opener = CLOSING_PAIRS[char]
    break unless opener && body.count(opener) > body.count(char)

    body += char
    kept += 1
  end
  [body, trailing[kept..]]
end

def linkify_text_node(node)
  document = node.document
  linked = false

  # split with a capture group alternates [separator, token, separator, token, ...]
  pieces = node.content.split(TOKEN_PATTERN).each_with_index.flat_map do |part, index|
    next [part] if index.even? || !part.match?(/[.@:]/)

    leading = part[LEADING_PUNCTUATION].to_s
    rest = part.delete_prefix(leading)
    body, trailing = split_trailing_punctuation(rest)
    embedded, candidate = split_embedded_scheme(body)
    leading += embedded

    href, attributes, text = link_href_for(candidate)
    next [part] unless href

    linked = true
    [leading, document.create_element('a', text, href: href, **attributes),
     candidate.delete_prefix(text) + trailing]
  end
  return unless linked

  fragment = document.create_element('span')
  pieces.each do |piece|
    next if piece.is_a?(String) && piece.empty?

    fragment.add_child(piece.is_a?(String) ? Nokogiri::XML::Text.new(piece, document) : piece)
  end

  # Replace the single text node with all the new nodes at once
  node.replace(fragment.children)
end

def bare_form(url)
  url.to_s.delete_prefix('https://').delete_prefix('http://').chomp('/')
end

# True when the link text is just the URL (before or after normalization, e.g. IDN/punycode).
def bare_link?(text, original_href, final_href)
  return false unless original_href

  text_url = text.match?(HTTP_URL_PREFIX) ? text : "https://#{text}"
  normalized_text = normalized_http_url(text_url)
  expected = [bare_form(text)]
  expected << bare_form(percent_encode_url(normalized_text)) if normalized_text

  [original_href, final_href].any? { |h| expected.include?(bare_form(h)) }
end

POST_BAKE = Kitchen::BookRecipe.new(book_short_name: :post_bake) do |doc|
  include Kitchen::Directions

  book = doc.book

  BakeOrderHeaders.v2(within: book)

  convert_textual_links(doc.raw)
  book.search('a').each do |anchor|
    text = anchor.text.gsub(/\s+/, ' ').strip

    href = anchor[:href]
    if href&.match?(/\Ahttps?:\/\//i)
      anchor[:href] = percent_encode_url(normalized_http_url(href) || href)
    end

    next if text.empty?

    anchor[:'aria-label'] ||= I18n.t(:generic_link_desc, link_text: text)

    next unless href

    anchor[:'data-bare-link'] = 'true' if bare_link?(text, href, anchor[:href])
  end
end
