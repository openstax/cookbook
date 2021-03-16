# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::ElementEnumeratorFactory do
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
      Kitchen::UnitElementEnumerator
    ].each do |enumerator_class|
      it "is created by #{enumerator_class}" do
        expect(described_class).to receive(:new)
        enumerator_class.factory
      end
    end
  end
end
