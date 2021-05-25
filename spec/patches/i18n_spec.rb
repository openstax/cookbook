# frozen_string_literal: true

RSpec.describe I18n do
  it 'wraps setting of locale' do
    expect(described_class).to receive(:clear_string_sorter)
    expect(described_class).to receive(:original_locale=).with(described_class.locale)
    described_class.locale = described_class.locale
  end
end
