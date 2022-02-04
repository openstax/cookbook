# frozen_string_literal: true

require 'spec_helper'

RSpec.describe String do

  describe '#uncapitalize' do
    it 'downcases the first letter of self, returning a new string' do
      expect('CHEESE!'.uncapitalize).to eq('cHEESE!')
    end
  end

end
