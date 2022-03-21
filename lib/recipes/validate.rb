# frozen_string_literal: true

require_relative '../kitchen/book_recipe'
require 'set'

# Offers some validation for baked output. Run after each recipe.
# Does NOT transform any of the content.
VALIDATE_OUTPUT = Kitchen::BookRecipe.new(book_short_name: :validate) do |doc|
  # Check for duplicate IDs
  def warn_if_already_seen(id)
    duplicate_ids_to_ignore = %w[author-1 author-2 publisher-1 publisher-2 publisher-3 publisher-4
                                 copyright-holder-1 copyright-holder-2 copyright-holder-3].freeze
    @already_seen_ids ||= Set.new
    if @already_seen_ids.include?(id) && !duplicate_ids_to_ignore.include?(id)
      puts "warning! duplicate id found for #{id}"
    end
    @already_seen_ids.add(id)
  end

  # ADD FURTHER VALIDATION STEPS HERE

  doc.traverse do |child|
    next if child.text? || child.document?

    warn_if_already_seen(child[:id]) if child[:id]
  end
end
