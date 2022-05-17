# frozen_string_literal: true

module Kitchen::Directions::BakeAppendixFeatureTitles
  class V1
    def bake(section:, selector:)
      # Remoe feature section old title if exists
      section.first('[data-type="title"]')&.trash
      title = <<~HTML
        <h2 data-type="title">
          #{I18n.t(:"appendix_sections.#{selector}")}
        </h2>
      HTML

      section.prepend(child: title)
    end
  end
end
