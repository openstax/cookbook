# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeHighlightedCode do
  let(:book) do
    book_containing(html:
      <<~HTML
        <div>
          <code>This is code without a data-lang</code>
          <code class="python">This code should have data-lang="python"</code>
          <code class="ruby">This code should have data-lang="ruby"</code>
          <pre>This should only have a pre tag</pre>
          <pre class="python">This should have data-lang="python"</pre>
          <pre class="python" data-lang="python">This should have data-lang="python" (unchanged)</pre>
          <code class="python">This code should have data-lang="python"</code>
          <pre class="python" data-lang="python">This should have class python and data-lang python (unchanged)</pre>
          <pre class="javascript">This should not have any data-lang attribute</pre>
          <code class="javascript">This should not have any data-lang attribute</code>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(book: book, languages: %w[python ruby])
    expect(book.body).to match_snapshot_auto
  end
end
