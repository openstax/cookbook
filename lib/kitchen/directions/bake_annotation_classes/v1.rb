# frozen_string_literal: true

module Kitchen::Directions::BakeAnnotationClasses
  class V1
    def bake(chapter:)
      chapter.search('p.annotation').each do |annotation|
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
        chapter.search("p.#{annotation_icon_class}").each do |annotation_with_icon_class|
          annotation_with_icon_class.search('div.os-icons').first.append(child:
            <<~HTML
              <span class = "#{annotation_icon_class}"></span>
            HTML
          )
        end
      end
    end
  end
end
