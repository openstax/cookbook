# frozen_string_literal: true

require 'set'

DUPLICATE_IDS_TO_IGNORE = %w[author-1 author-2 publisher-1 publisher-2 publisher-3 publisher-4
                             copyright-holder-1 copyright-holder-2 copyright-holder-3].freeze

# In HTML attribute order doesn't matter, but to make sure our diffs are useful resort all
# attributes.

def sort_attributes(element)
  attributes = element.attributes
  attributes.each do |key, _|
    element.remove_attribute(key)
  end
  sorted_keys = attributes.keys.sort
  sorted_keys.each do |key|
    value = attributes[key].to_s
    element[key] = value
  end
end

# Strips trailing whitespace from class names

def sort_classes_strip_whitespace(element)
  element[:class] = element[:class].split(' ').sort.join(' ') if element[:class]
end

# Check for duplicate IDs

def warn_if_already_seen(id)
  @already_seen_ids ||= Set.new
  if @already_seen_ids.include?(id) && !DUPLICATE_IDS_TO_IGNORE.include?(id)
    puts "warning! duplicate id found for #{id}"
  end
  @already_seen_ids.add(id)
end

# Main normalize function for an XML document

def normalize(doc)
  doc.traverse do |child|
    next if child.text? || child.document?

    sort_classes_strip_whitespace(child)
    sort_attributes(child)
    warn_if_already_seen(child[:id]) if child[:id]
  end
end
