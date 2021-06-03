# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Translations' do
  describe 'uses the right translation in: ' do
    it 'spanish' do
      with_locale(:es) do
        expect(I18n.t(:equation)).to match('Ecuación')
        expect(I18n.t(:chapter_review)).to match('Revisión Del Capítulo')
        expect(I18n.t(:learning_objectives)).to match('Objetivos De Aprendizaje')
      end
    end

    it 'polish' do
      with_locale(:pl) do
        expect(I18n.t(:equation)).to match('Równanie')
        expect(I18n.t(:chapter_review)).to match('Podsumowanie rozdziału')
        expect(I18n.t(:learning_objectives)).to match('Cel dydaktyczny')
      end
    end
  end
end
