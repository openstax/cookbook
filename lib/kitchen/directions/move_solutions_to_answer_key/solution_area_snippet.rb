# frozen_string_literal: true

module Kitchen::Directions::SolutionAreaSnippet
  def self.v1(title:, solutions_clipboard:)
    <<~HTML
      <div class="os-solution-area">
        #{title}
        #{solutions_clipboard.paste}
      </div>
    HTML
  end
end
