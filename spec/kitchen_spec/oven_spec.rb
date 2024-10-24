# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'
require 'tmpdir'

RSpec.describe Kitchen::Oven do
  describe 'BakeProfile' do
    it 'can be written to string' do
      expect(Kitchen::Oven::BakeProfile.new.to_s).to eq <<~STRING
        Open:  ?? s
        Parse: ?? s
        Bake:  ?? s
        Write: ?? s
      STRING
    end
  end

  describe '#bake' do
    it 'does nada when there are no recipes' do
      expect_bakes(input_xml: "<div>Howdy</div>\n", recipes: [], output_xml: "<div>Howdy</div>\n")
    end

    it 'bakes' do
      recipe = Kitchen::Recipe.new do |document|
        document.search('div').first.name = 'booyah'
      end

      expect_bakes(input_xml: "<div>Howdy</div>\n", recipes: recipe, output_xml: "<booyah>Howdy</booyah>\n")
    end

    it 'converts filepath to resources' do
      recipe = Kitchen::Recipe.new do |document, resources|
        resources[resources.keys.first][:hello] = 'hiya'
        document.search('div').first.append(child: "<div>#{resources[resources.keys.first][:hello]}</div>")
      end

      expect_bakes(
        input_xml: "<div>Howdy</div>\n", recipes: recipe, output_xml: "<div>Howdy<div>hiya</div></div>\n",
        resources_hash: [
          { "abc": { "hello": 'world' } },
          { "def": { "water": 'melon' } }
        ]
      )
    end

    it 'bakes with temporary, explicit, recipe-specific locales' do
      recipe = Kitchen::Recipe.new(locales_dir: "#{__dir__}/support/recipe_specific_locales_1") do |document|
        document.search('div').first.replace_children(with: I18n.t(:some_recipe_specific_term))
      end

      expect_bakes(input_xml: '<div></div>', recipes: recipe, output_xml: "<div>Howdy!</div>\n")
      expect(I18n.t(:some_recipe_specific_term)).to match(/Translation missing/)
    end

    it 'bakes with temporary, auto-discovered, recipe-specific locales' do
      recipe = Kitchen::Recipe.new do |document|
        document.search('div').first.replace_children(with: I18n.t(:some_recipe_specific_term))
      end

      expect_bakes(input_xml: '<div></div>', recipes: recipe, output_xml: "<div>Auto-discovered!</div>\n")
      expect(I18n.t(:some_recipe_specific_term)).to match(/Translation missing/)
    end

    it 'autodetects the language' do
      recipe = Kitchen::Recipe.new do |document|
        document.search('div').first.replace_children(with: I18n.t(:appendix))
      end

      expect_bakes(input_xml: '<div lang="es"></div>',
                   recipes: recipe,
                   output_xml: "<div lang=\"es\" xml:lang=\"es\">Apéndice</div>\n")
    end

    context 'when both recipe-specific and kitchen locales exist' do
      # This is a rare case when we do not call `stub_locales` because that messes with how
      # locales are found, and here we want to test our recipe-specific chaining logic.

      it 'uses the recipe-specific ones preferrentially' do
        recipe = Kitchen::Recipe.new do |document|
          document.search('div').first.replace_children(with:
            [
              I18n.t(:some_recipe_specific_term), # only in recipe translations
              I18n.t(:figure),                    # in recipe and kitchen translations
              I18n.t(:chapter)                    # only in kitchen translations
            ].join(',')
          )
        end

        expect_bakes(input_xml: '<div></div>', recipes: recipe, output_xml: "<div>Auto-discovered!,Figgy,Chapter</div>\n")
        expect(I18n.t(:some_recipe_specific_term)).to match(/Translation missing/)
      end
    end

    def expect_bakes(input_xml:, recipes:, output_xml:, resources_hash: nil)
      input_file = Tempfile.new.tap { |file| file.write(input_xml); file.rewind }
      output_file = Tempfile.new

      if resources_hash
        Dir.mktmpdir do |directory|
          resources_hash.each do |resource|
            key = resource.keys.first
            File.open("#{directory}/#{key}.json", 'w') { |file| file.write(resource[key].to_json); file.rewind }
          end
          described_class.bake(
            input_file: input_file.path, recipes: [recipes].flatten,
            output_file: output_file.path, resource_dir: directory
          )
        end
      else
        described_class.bake(input_file: input_file.path,
                             recipes: [recipes].flatten,
                             output_file: output_file.path)

        expect(output_file.read).to eq output_xml
      end
    end
  end
end
