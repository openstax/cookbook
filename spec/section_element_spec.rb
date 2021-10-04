# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::SectionElement do

  let(:section) do
    book_containing(html:
      <<~HTML
        <section>
          <div data-type="exercise">Exercise 1</div>
        </section>
      HTML
    ).sections.first
  end

  it 'can be retrieved as an ancestor by its descendants' do
    expect(section.exercises.first.ancestor(:section)).to be_truthy
  end

end
