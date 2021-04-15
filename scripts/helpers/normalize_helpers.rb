# frozen_string_literal: true

require 'set'

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

# Legacy bakings of unnumbered tables include a bogus number, delete it

def remove_bogus_number_from_unnumbered_tables(element)
  return unless element.name == 'table' && (element[:class] || '').include?('unnumbered')

  element.remove_attribute('summary')
end

# Sometimes there is `class=' '`, get rid of these

def remove_blank_classes(element)
  element.attributes.each do |key, value|
    element.remove_attribute(key) if key == 'class' && value.to_s.strip == ''
  end
end

# Strips trailing whitespace from class names

def sort_classes_strip_whitespace(element)
  element[:class] = element[:class].split(' ').sort.join(' ') if element[:class]
end

# The index of copied elements (the number in _copy_23) isn't meaningful so
# hide it.

def mask_copied_id_numbers(element, existing_ids)
  return unless element[:id]

  ids_to_exclude = %w[author-1 publisher-1 publisher-2 copyright-holder-1]
  if existing_ids.include?(element[:id]) && !ids_to_exclude.include?(element[:id])
    puts "warning! duplicate id found for #{element[:id]}"
  end
  existing_ids.add(element[:id])
  element[:id] = element[:id].gsub(/_copy_(\d+)$/, '_copy_XXX')
end

def normalize(doc)
  ids_set = Set.new
  doc.traverse do |child|
    mask_copied_id_numbers(child, ids_set)
    next if child.text? || child.document?

    remove_bogus_number_from_unnumbered_tables(child)
    remove_blank_classes(child)
    sort_classes_strip_whitespace(child)
    sort_attributes(child)
  end
end
