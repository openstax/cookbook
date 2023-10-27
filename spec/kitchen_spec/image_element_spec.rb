# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::ImageElement do
  let(:valid_images) do
    book_containing(html:
      <<~HTML
        <img src="../resources/abcd1234" />
        <img src="../resources/xyz987" />
      HTML
    ).images
  end

  let(:bad_images) do
    book_containing(html:
      <<~HTML
        <img src="bad-format" />
        <img src="../../src/resources/imagekey123.jpg" />
      HTML
    ).images
  end

  describe '#resource_key' do
    it 'gets key from src' do
      expect(valid_images[0].resource_key).to eq :abcd1234
      expect(valid_images[1].resource_key).to eq :xyz987
    end

    it 'errors if src is in the wrong format' do
      expect { bad_images[0].resource_key }.to raise_error(RuntimeError, /ERROR: Invalid format .* <img src="bad-format"\/>/)
      expect { bad_images[1].resource_key }.to raise_error(RuntimeError, /ERROR: Invalid format .* <img src="\.\.\/\.\.\/src\/resources\/imagekey123\.jpg"\/>/)
    end
  end
end
