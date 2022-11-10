# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::IdTracker do
  let(:instance) { described_class.new }

  describe '#record_id_cut' do
    it 'decrement ID count by 1' do
      instance.record_id_cut('bar')
      expect(instance.first_id?('bar')).to be true
    end
  end

  describe '#record_id_pasted' do
    it 'records if the id has been pasted more than once' do
      instance.record_id_pasted('zoo')
      expect(instance.first_id?('zoo')).to be true
      instance.record_id_pasted('zoo')
      expect(instance.first_id?('zoo')).nil?
    end
  end
end
