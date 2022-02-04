# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::ElementEnumeratorFactory do
  let(:element1) do
    chapter_element('<p>Hi!</p>')
  end

  describe 'specific enumerators create a factory' do
    [
      Kitchen::ChapterElementEnumerator,
      Kitchen::CompositePageElementEnumerator,
      Kitchen::ExampleElementEnumerator,
      Kitchen::FigureElementEnumerator,
      Kitchen::NoteElementEnumerator,
      Kitchen::PageElementEnumerator,
      Kitchen::TableElementEnumerator,
      Kitchen::TermElementEnumerator,
      Kitchen::TypeCastingElementEnumerator,
      Kitchen::UnitElementEnumerator,
      Kitchen::CompositePageElementEnumerator
    ].each do |enumerator_class|
      it "is created by #{enumerator_class}" do
        expect(described_class).to receive(:new)
        enumerator_class.factory
      end
    end
  end

  it 'raises when a specific enumerator has CSS missing the substitution character' do
    expect {
      element1.pages('.foo') # should be '$.foo' otherwise no point to using `pages`
    }.to raise_error(/is missing the substitution character/)
  end
end
