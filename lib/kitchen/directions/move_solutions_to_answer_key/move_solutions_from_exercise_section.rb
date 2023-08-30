# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsFromExerciseSection
  def self.v1(within:, append_to:, section_class:, title_number: nil, options: {
    add_title: true,
    in_appendix: false
  })
    options.reverse_merge!(
      add_title: true,
      in_appendix: false
    )
    V1.new.bake(within: within, append_to: append_to, section_class: section_class,
                title_number: title_number, options: options)
  end

  class V1
    def bake(within:, append_to:, section_class:, title_number:, options:)
      solutions_clipboard = \
        if within.instance_of?(Kitchen::SectionElement)
          within.solutions.cut
        else
          within.search("section.#{section_class}").solutions.cut
        end

      return if solutions_clipboard.items.empty?

      if options[:add_title]
        title_text = \
          if title_number
            I18n.t(:"eoc.#{section_class}", number: title_number)
          elsif options[:in_appendix]
            I18n.t(:"appendix_sections.#{section_class}")
          else
            I18n.t(:"eoc.#{section_class}")
          end

        title = <<~HTML
          <h3 data-type="title">
            <span class="os-title-label">#{title_text}</span>
          </h3>
        HTML

        append_to.append(child:
          Kitchen::Directions::SolutionAreaSnippet.v1(
            title: title, solutions_clipboard: solutions_clipboard
          )
        )
      else
        append_to.append(child: solutions_clipboard.paste)
      end
    end
  end
end
