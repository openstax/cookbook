# frozen_string_literal: true

@solution1 = Kitchen::Recipe.new do |doc|

  doc.search("[data-type='chapter']").each do |chapter|
    review_questions = chapter.search('.review-questions').cut
    critical_thinking = chapter.search('.critical-thinking').cut

    [review_questions, critical_thinking].each do |clipboard|
      clipboard.each do |element|
        element.first('h3').trash
      end
    end

    chapter.append(child: <<~HTML
      <div class="eoc">
        <h2 data-type="document-title">End of Chapter Stuff</h2>
        <div class="critical-thinking-container">
          <div class="os-title">Critical Thinking Questions</div>
          #{critical_thinking.paste}
        </div>
        <div class="review-questions-container">
          <div class="os-title">Review Questions</div>
          #{review_questions.paste}
        </div>
      </div>
    HTML
    )
  end

end
