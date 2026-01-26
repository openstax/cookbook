# frozen_string_literal: true

# Pre-compile the regex once
URL_PATTERN = /(https?:\/\/[^\s<>"]+[^\s<>".,;:!?)\]}]|www\.[^\s<>"]+[^\s<>".,;:!?)\]}])/i
QUICK_CHECK = /\.|:\/\/|www/ # Fast check before running heavy regex

def convert_textual_links(element)
  # 1. Prune the search: If we are in an <a> tag, stop recursing.
  return if element.name == 'a'

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
  matches = content.scan(URL_PATTERN)
  return if matches.empty?

  fragment = node.document.create_element('span')
  parts = content.split(URL_PATTERN)

  parts.each do |part|
    if part =~ URL_PATTERN
      href = part.downcase.start_with?('www.') ? "https://#{part}" : part
      # Create <a> tag directly
      anchor = node.document.create_element('a', part, href: href)
      fragment.add_child(anchor)
    else
      # Only add text nodes if they aren't empty
      fragment.add_child(Nokogiri::XML::Text.new(part, node.document)) unless part.empty?
    end
  end

  # Replace the single text node with all the new nodes at once
  node.replace(fragment.children)
end

POST_BAKE = Kitchen::BookRecipe.new(book_short_name: :post_bake) do |doc|
  book = doc.book

  BakeOrderHeaders.v2(within: book)

  convert_textual_links(doc.raw)
  book.search('a:not([aria-label])').each do |anchor|
    text_builder = anchor.search('.//text()').map { |t| t.text.strip }
    text_builder = text_builder.filter { |t| !t.empty? }
    text = text_builder.to_a.join(' ')
    next if text.empty?

    label = I18n.t(:generic_link_desc, link_text: text)
    anchor[:'aria-label'] = label
  end
end
