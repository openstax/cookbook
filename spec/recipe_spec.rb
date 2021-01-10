require 'spec_helper'

RSpec.describe Kitchen::Recipe do
  let(:dummy_document) { Kitchen::Document.new(nokogiri_document: nil) }

  context '#initialize' do
    it 'requires a block' do
      expect { described_class.new }.to raise_error(Kitchen::RecipeError)
    end
  end

  it 'captures the source location' do
    recipe = described_class.new {}
    expect(recipe.source_location).to eq __FILE__
  end

  context '#document=' do
    it 'works for a Kitchen::Document' do
      expect { (described_class.new {}).document = dummy_document }.not_to raise_error
    end

    it 'blows up when not a Kitchen::Document' do
      expect { (described_class.new {}).document = 'foo' }.to raise_error(StandardError)
    end
  end

  context '#bake' do
    it 'calls the recipe block with the document' do
      expect(target = double).to receive(:foo).with(nil)
      recipe = described_class.new do |document|
        target.foo(document)
      end
      recipe.bake
    end

    it 'prints RecipeErrors' do
      expect_error_print_and_exit_on_bake(error_class: Kitchen::RecipeError)
    end

    it 'prints ElementNotFoundError' do
      expect_error_print_and_exit_on_bake(error_class: Kitchen::RecipeError)
    end

    it 'prints Nokogiri::CSS::SyntaxError' do
      expect_error_print_and_exit_on_bake(error_class: Nokogiri::CSS::SyntaxError)
    end

    context 'ArgumentError' do
      it 'prints when a callstack location matches the source location' do
        expect_error_print_and_exit_on_bake(error_class: ArgumentError)
      end

      it 'reraises when no callstack location matches the source location' do
        expect_reraise_on_bake_with_unexpected_source_location(error_class: ArgumentError)
      end
    end

    context 'NoMethodError' do
      it 'prints when a callstack location matches the source location' do
        expect_error_print_and_exit_on_bake(error_class: NoMethodError)
      end

      it 'reraises when no callstack location matches the source location' do
        expect_reraise_on_bake_with_unexpected_source_location(error_class: NoMethodError)
      end
    end

    context 'NameError' do
      it 'prints when a callstack location matches the source location' do
        expect_error_print_and_exit_on_bake(error_class: NameError)
      end

      it 'reraises when no callstack location matches the source location' do
        expect_reraise_on_bake_with_unexpected_source_location(error_class: NameError)
      end
    end
  end

  def expect_reraise_on_bake_with_unexpected_source_location(error_class:)
    recipe_block = proc { raise error_class }
    allow(recipe_block).to receive(:source_location).and_return(['foobar'])
    expect(Kitchen::Debug).not_to receive(:print_recipe_error)
    expect { (described_class.new &recipe_block).bake }.to raise_error(error_class)
  end

  def expect_error_print_and_exit_on_bake(error_class:)
    recipe_block = proc { raise error_class }
    expect(Kitchen::Debug).to receive(:print_recipe_error)
    expect { (described_class.new &recipe_block).bake }.to raise_error(SystemExit)
  end
end
