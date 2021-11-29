# frozen_string_literal: true

module Kitchen::Directions::BakeAnnotationClasses
  class V1
    def bake(book:)
      book.search('p.annotation').each do |annotation|
        annotation.wrap_children('span', class: 'os-text')
        annotation.prepend(child:
          <<~HTML
            <div class="os-icons"></div>
          HTML
        )
      end
      annotation_icon_classes = %w[linguistic-icon
                                   culture-icon
                                   dreaming-icon
                                   visual-icon
                                   speech-icon
                                   auditory-icon
                                   kinesthetic-icon]
      annotation_icon_classes.each do |annotation_icon_class|
        book.search("p.#{annotation_icon_class}").each do |annotation_with_icon_class|
          annotation_with_icon_class.search('div.os-icons').first&.name = 'span'

          icon_title = I18n.t(:"annotation_icons.#{annotation_icon_class}.title")

          annotation_with_icon_class.search('span.os-icons').first.append(child:
            <<~HTML
              <span
                class = "#{annotation_icon_class}"
                role="img"
                title="#{icon_title}"
                aria-label="#{icon_title}"
              ></span>
            HTML
          )
        end
      end
    end
  end
end
