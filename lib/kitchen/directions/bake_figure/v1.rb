# frozen_string_literal: true

module Kitchen::Directions::BakeFigure
  class V1
    renderable

    def bake(figure:, number:, cases: false)
      @number = number
      @cases = cases
      warn 'warning! exclude unnumbered figures from `BakeFigure` loop' if figure.unnumbered?
      figure.wrap(%(<div class="os-figure#{' has-splash' if figure.has_class?('splash')}">))

      # Store label information
      figure.target_label(label_text: 'figure', custom_content: number, cases: cases)
      @title_label = "#{I18n.t("figure#{'.nominative' if @cases}")} "
      @title = figure.title&.cut
      @caption = figure.caption&.cut
      figure.append(sibling: render(file: 'caption_container.xhtml.erb'))
    end
  end
end
