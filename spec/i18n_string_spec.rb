# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::I18nString do

  it 'sorts strings with accent marks' do
    items = []
    items.push(described_class.new('Hu'))
    items.push(described_class.new('Hückel'))
    items.push(described_class.new('Héroult'))
    items.push(described_class.new('Hunk'))
    expect(items.sort).to eq %w[Héroult Hu Hückel Hunk]
  end

  it 'sorts strings in language specific way' do
    with_locale(:pl) do
      items = []
      items.push(described_class.new('Wąski'))
      items.push(described_class.new('Świat'))
      items.push(described_class.new('Szum'))
      items.push(described_class.new('Wazon'))
      expect(items.sort).to eq %w[Szum Świat Wazon Wąski]
    end
  end

end
