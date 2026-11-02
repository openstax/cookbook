# frozen_string_literal: true

require 'uri'
require 'addressable/uri'

# Pre-compile the regex once
# Capture unsupported URI schemes as a whole so an email inside one is not linkified separately.
SCHEME_URL_PATTERN = /[A-Za-z][A-Za-z0-9+.-]*:[^\s<>"]+[^\s<>".,;:!?)\]'}]/i
# Match complete scheme-less hostnames, without matching a domain fragment inside another token.
BARE_DOMAIN_PATTERN = /(?<!:\/\/)(?<!:)(?<![\p{L}\p{N}._+@\/-])(?:[\p{L}\p{N}](?:[\p{L}\p{M}\p{N}-]*[\p{L}\p{N}])?\.)+(?:[\p{L}]{2,}|xn--[A-Za-z0-9-]{2,})(?:[\/?#:][^\s<>"]*[^\s<>".,;:!?)\]'}])?(?![\p{L}\p{N}_+@-]|\.(?:[\p{L}\p{N}_+@-]|\.))/i
BARE_DOMAIN_CANDIDATE_PATTERN = /\A#{BARE_DOMAIN_PATTERN.source}\z/i
URL_PATTERN = Regexp.union(SCHEME_URL_PATTERN, BARE_DOMAIN_PATTERN)
EMAIL_PATTERN = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/
EMAIL_CANDIDATE_PATTERN = /\A#{EMAIL_PATTERN.source}\z/
LINK_PATTERN = /(#{Regexp.union(EMAIL_PATTERN, URL_PATTERN).source})/
QUICK_CHECK = /:\/\/|www|@|[\p{L}\d]\.[\p{L}\d]/ # Fast check before running heavy regex
LINK_IGNORE = %w[a dt dd code].freeze
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

def convert_textual_links(element)
  # 1. Prune the search: If we are in an ignored tag, stop recursing.
  return if LINK_IGNORE.include?(element.name)

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

def linkify_text_node(node)
  content = node.content
  return unless content =~ LINK_PATTERN

  fragment = node.document.create_element('span')
  parts = content.split(LINK_PATTERN)

  parts.each do |part|
    if EMAIL_CANDIDATE_PATTERN.match?(part)
      anchor = node.document.create_element('a',
                                            part,
                                            href: "mailto:#{part}",
                                            'aria-label': I18n.t(:email_link_desc, email: part),
                                            'data-bare-link': 'true')
      fragment.add_child(anchor)
    elsif URL_PATTERN.match?(part)
      href = if part.match?(/\Ahttps?:\/\//i)
               part
             elsif BARE_DOMAIN_CANDIDATE_PATTERN.match?(part)
               "https://#{part}"
             end
      href = normalized_http_url(href) if href

      if href
        anchor = node.document.create_element('a', part, href: href)
        fragment.add_child(anchor)
      else
        fragment.add_child(Nokogiri::XML::Text.new(part, node.document))
      end
    else
      # Only add text nodes if they aren't empty
      fragment.add_child(Nokogiri::XML::Text.new(part, node.document)) unless part.empty?
    end
  end

  # Replace the single text node with all the new nodes at once
  node.replace(fragment.children)
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

    clean_text = text.delete_prefix('https://').delete_prefix('http://').chomp('/')
    clean_href = href.delete_prefix('https://').delete_prefix('http://').chomp('/')

    anchor[:'data-bare-link'] = 'true' if clean_text == clean_href
  end
end
