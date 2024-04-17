# frozen_string_literal: true

module Kitchen::Directions::BakeChapterGlossary
  class V2
    # Bakes glossary list before moving section to EOC
    # Section should be moved to EOC in `recipe` file by `MoveCustomSectionToEocContainer` module

    def bake(chapter:)
      chapter.search('.key-terms').search('[data-type="list"]').each do |terms_list|
        terms_list.search('[data-type="item"]:not(:last-child)').each do |not_last_item|
          not_last_item.append(sibling:
            <<~HTML.chomp
              <span class="os-divider">,</span>
            HTML
          )
        end
      end
    end
  end
end
