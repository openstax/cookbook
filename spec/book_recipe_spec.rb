RSpec.describe Kitchen::BookRecipe do
  context 'book_short_name' do
    it 'is :not_set when not set' do
      expect(described_class.new(){}.book_short_name).to eq :not_set
    end

    it 'is a symbol when initialized with a string' do
      expect(
        described_class.new(book_short_name: 'foo'){}.book_short_name
      ).to eq :foo
    end
  end

  it 'converts its Document to a BookDocument' do
    recipe = described_class.new(){}
    recipe.document = Kitchen::Document.new(nokogiri_document: nil)
    expect(recipe.document).to be_a_kind_of Kitchen::BookDocument
  end
end
