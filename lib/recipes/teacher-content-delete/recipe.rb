# frozen_string_literal: true

# Removes teacher-only content (class `os-teacher`) from a book. Run it BEFORE the book's own
# recipe so that numbering, ToC, index, and links are all computed without the removed content.
# Example: 'algebra-1' => [TEACHER_CONTENT_DELETE_RECIPE, ALGEBRA_1_RECIPE]
TEACHER_CONTENT_DELETE_RECIPE = Kitchen::BookRecipe.new(
  book_short_name: :teacher_content_delete
) do |doc|
  include Kitchen::Directions

  book = doc.book

  book.search('.os-teacher').each(&:trash)
end
