# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Element do

  let(:element1) do
    new_element(
      <<~HTML
        <div id="divId" class="class1 class2" data-type="a-div">
          <p id="pId"><span>Hi there</span></p>
        </div>
      HTML
    )
  end

  it 'can get the name' do
    expect(element1.name).to eq 'div'
  end

  it 'can set the name' do
    element1.name = 'h2'
    expect(element1.to_s).to start_with('<h2')
  end

  it 'can get an arbitrary attribute' do
    expect(element1['data-type']).to eq 'a-div'
  end

  it 'can set an arbitrary attribute' do
    element1['some_attr'] = 'hi'
    expect(element1.to_s).to match(/div.*some_attr="hi"/)
  end

  it 'can remove an arbitrary attribute' do
    element1.remove_attribute('data-type')
    expect(element1.to_s).not_to match(/some_attr/)
  end

  it 'can add a class' do
    element1.add_class('new_class')
    expect(element1.to_s).to match(/class="class1 class2 new_class"/)
  end

  it 'can remove a class' do
    element1.remove_class('class1')
    expect(element1.to_s).to match(/class="class2"/)
  end

  it 'can say if has a class' do
    expect(element1.has_class?('class2')).to eq true
  end

  it 'can return an array of classes' do
    expect(element1.classes).to contain_exactly('class1', 'class2')
  end

  it 'can get the ID' do
    expect(element1.id).to eq 'divId'
  end

  it 'can set the ID' do
    element1.id = 'blah'
    expect(element1.to_s).to match(/<div id="blah"/)
  end

  it 'can get the text contents' do
    expect(element1.text).to match(/\n.*Hi there\n/)
  end

  it 'can wrap itself' do
    element1.wrap("<div id='outer'>")
    expect(element1.raw.parent[:id]).to eq 'outer'
  end

  xit 'can return its children' do

  end

  it 'can be converted to an HTML string' do
    expect("#{element1.to_html}\n").to eq(
      <<~HTML
        <div id="divId" class="class1 class2" data-type="a-div">
          <p id="pId"><span>Hi there</span></p>
        </div>
      HTML
    )
  end

  describe '#cut and #paste' do
    let!(:parent) { element1.parent }

    context 'when using clipboards' do
      it 'can cut to a named clipboard' do
        element1.cut(to: :something)
        expect(parent.to_s).not_to match(/divId/)
        expect(element1.clipboard(name: :something).first.id).to eq 'divId'
      end

      it 'can cut to an existing clipboard' do
        clipboard = Kitchen::Clipboard.new
        element1.cut(to: clipboard)
        expect(parent.to_s).not_to match(/divId/)
        expect(clipboard.first.id).to eq 'divId'
      end

      it 'uses same ID on first paste and no IDs on the second or third paste' do
        clipboard = Kitchen::Clipboard.new
        element1.cut(to: clipboard)
        expect(clipboard.paste).to match(/divId"/)
        expect(clipboard.paste).not_to match(/id="/)
        expect(clipboard.paste).not_to match(/id="/)
      end

      it 'uses the same ID when cutting, pasting, cutting, and pasting again' do
        clipboard = Kitchen::Clipboard.new
        element1.cut(to: clipboard)
        expect(clipboard.paste).to match(/divId"/)
        element1.cut(to: clipboard)
        expect(clipboard.paste).to match(/divId"/)
      end
    end

    context 'without clipboards' do
      it 'can cut avoiding clipboards' do
        the_cut_element = element1.cut
        expect(parent.to_s).not_to match(/divId/)
        expect(the_cut_element.id).to eq 'divId'
      end

      it 'uses same ID on first paste and no IDs on second and third paste' do
        the_cut_element = element1.cut
        expect(the_cut_element.paste).to match(/divId"/)
        expect(the_cut_element.paste).not_to match(/id="/)
        expect(the_cut_element.paste).not_to match(/id="/)
      end

      it 'uses the same ID when cutting, pasting, cutting, and pasting again' do
        the_cut_element = element1.cut
        expect(the_cut_element.paste).to match(/divId"/)
        the_cut_element_again = element1.cut
        expect(the_cut_element_again.paste).to match(/divId"/)
      end
    end
  end

  describe '#copy and #paste' do
    let!(:parent) { element1.parent }

    context 'when using clipboards' do
      it 'can copy to a named clipboard' do
        element1.copy(to: :something)
        expect(parent.to_s).to match(/divId/)
        expect(element1.clipboard(name: :something).first.id).to eq 'divId'
      end

      it 'can copy to an existing clipboard' do
        clipboard = Kitchen::Clipboard.new
        element1.copy(to: clipboard)
        expect(parent.to_s).to match(/divId/)
        expect(clipboard.first.id).to eq 'divId'
      end

      it 'uses unique IDs all pastes' do
        clipboard = Kitchen::Clipboard.new
        element1.copy(to: clipboard)
        expect(clipboard.paste).not_to match(/id="/)
        expect(clipboard.paste).not_to match(/id="/)
      end

      it 'uses no IDs when copying and pasting twice' do
        clipboard = Kitchen::Clipboard.new
        element1.copy(to: clipboard)
        expect(clipboard.paste).not_to match(/id="/)
        element1.copy(to: clipboard)
        expect(clipboard.paste).not_to match(/id="/)
      end

      it 'uses no IDs when copying 3 times' do
        clipboard = Kitchen::Clipboard.new
        element1.copy(to: clipboard)
        element1.copy(to: clipboard)
        element1.copy(to: clipboard)
        expect(clipboard.paste).not_to match(/id="/)
      end
    end

    context 'without clipboards' do
      it 'can copy' do
        the_copied_element = element1.copy
        expect(parent.to_s).to match(/divId/)
        expect(the_copied_element.id).to eq 'divId'
      end

      it 'uses no IDs all duplicate pastes' do
        the_copied_element = element1.copy
        expect(the_copied_element.paste).not_to match(/id="/)
        expect(the_copied_element.paste).not_to match(/id="/)
      end

      it 'keeps using no IDs even if copied & pasting multiple times' do
        the_copied_element = element1.copy
        expect(the_copied_element.paste).not_to match(/id="/)
        the_copied_element2 = element1.copy
        expect(the_copied_element2.paste).not_to match(/id="/)
      end
    end
  end

  describe '#first' do
    it 'records ancestry' do
      inner = element1.search('p').search('span').first
      expect(inner.ancestor('p').id).to eq 'pId'
    end
  end

  describe 'search_history' do
    it 'returns search history' do
      inner = element1.search('#pId').search('span').first
      expect(inner.search_history.to_s).to eq '[#pId] [span]'
    end
  end

end
