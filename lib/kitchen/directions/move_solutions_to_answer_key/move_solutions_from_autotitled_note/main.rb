# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsFromAutotitledNote
  def self.v1(page:, append_to:, note_class:, title: nil)
    V1.new.bake(page: page, append_to: append_to, note_class: note_class, title: title)
  end

  def self.v2(chapter:, append_to:, note_class:)
    V2.new.bake(chapter: chapter, append_to: append_to, note_class: note_class)
  end
end
