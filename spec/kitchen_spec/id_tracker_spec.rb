# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::IdTracker do
  let(:instance) { described_class.new }

  describe '#record_id_copied' do
    it 'increment ID count by 1' do
      instance.record_id_copied('foo')
      expect(instance.modified_id_to_paste('foo')).to eq 'foo_copy_1'
    end
  end

  describe '#record_id_cut' do
    it 'decrement ID count by 1' do
      instance.record_id_cut('bar')
      expect(instance.modified_id_to_paste('bar')).to eq 'bar'
    end
  end

  describe '#record_id_pasted' do
    it 'increment ID count by 1 if last operation was a paste' do
      instance.record_id_pasted('zoo')
      expect(instance.modified_id_to_paste('zoo')).to eq 'zoo'
      instance.record_id_pasted('zoo')
      expect(instance.modified_id_to_paste('zoo')).to eq 'zoo_copy_1'
    end
  end
end
