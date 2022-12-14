# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeInlineLists do
  let(:book) do
    book_containing(html:
      <<~HTML
        <div>
          <code>This is code without a data-lang</code>
          <code class="python">This code should have data-lang="python"</code>
          <pre>This should not change</pre>
          <pre class="python" data-type="python">This should not change</pre>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(book: book, languages: ["python"])
    expect(book.body).to match_snapshot_auto
  end
end
