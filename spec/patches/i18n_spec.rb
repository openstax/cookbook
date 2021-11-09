# frozen_string_literal: true

RSpec.describe I18n do
  it 'wraps setting of locale' do
    expect(described_class).to receive(:clear_string_sorter)
    expect(described_class).to receive(:original_locale=).with(described_class.locale)
    described_class.locale = described_class.locale
  end

  it 'transliterate character' do
    expect(described_class.character_to_group('Ć')).to eq 'C'
  end

  it 'return character when polish' do
    with_locale(:pl) do
      expect(described_class.character_to_group('Ć')).to eq 'Ć'
    end
  end
end
