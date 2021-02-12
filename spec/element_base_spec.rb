# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::ElementBase do

  let(:book) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="example" class="class1" id="div1">
            <p>This is a paragraph.</p>
          </div>
        HTML
      ))
  end

  let(:header_book) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <h1 data-type="document-title">
              <span class="os-text">Title1</span>
          </h1>
          <div data-type="example" class="class1" id="div1">
            <p>This is a paragraph.</p>
          </div>
        HTML
      ))
  end

  let(:searchable_book) do
    book_containing(html:
      chapter_element(
        <<~HTML
          <div data-type="page" id="page1">
            <div data-type="example" class="class1" id="example1">
              <p>This is an example.</p>
            </div>
            <figure id="figure1">can't touch this (stop! hammer time)</figure>
          </div>
          <div data-type="page" id="page2"> This is a page </div>
        HTML
      ))
  end

  let(:example) { book.first!('div[data-type="example"]') }

  let(:para) { book.first!('p') }

  describe '#has_class?' do
    it 'returns true if element has given class' do
      expect(example.has_class?('class1')).to eq true
    end

    it 'returns false if element does not have given class' do
      expect(example.has_class?('class2')).to eq false
    end
  end

  describe '#id' do
    it 'returns the element\'s ID' do
      expect(example.id).to eq 'div1'
    end
  end

  describe '#id=' do
    it 'sets the element\'s ID' do
      para.id = 'para1'
      expect(para.id).to eq 'para1'
    end
  end

  describe '#set' do
    it 'changes the tag name of an element' do
      book.set(:name, 'section')
      expect(book.name).to eq 'section'
    end

    it 'sets the value of a element\'s property' do
      book.set(:id, 'newDivID')
      expect(book.id).to eq 'newDivID'
    end

    it 'changes the tag name of an element and gives it a property and value' do
      p_matcher = /<p>This is a paragraph.<\/p>/
      span_matcher = /<span class="span1">This is a paragraph.<\/span>/
      expect do
        para.set(:name, 'span').set(:class, 'span1')
      end.to change(para, :to_html).from(p_matcher).to(span_matcher)
    end
  end

  describe '#ancestor' do
    let(:p_element) { book.chapters.pages.examples.search('p').first! }

    it 'returns element\'s ancestor of the given type' do
      expect(p_element.ancestor(:example).id).to eq 'div1'
    end

    it 'raises an error when there is no ancestor of the given type' do
      type = :figure
      expect do
        p_element.ancestor(type).id
      end.to raise_error("No ancestor of type '#{type}'")
    end
  end

  describe '#has_ancestor?' do
    let(:p_element) { book.chapters.pages.examples.search('p').first! }

    it 'returns true if element has ancestor of given type' do
      expect(p_element.has_ancestor?(:chapter)).to eq true
    end

    it 'returns false if element does not have ancestor of given type' do
      expect(p_element.has_ancestor?(:figure)).to eq false
    end
  end

  describe '#add_ancestors' do
    it 'add ancestors to an element' do
      ancestor_example = Kitchen::Ancestor.new(example)
      expect(para).to receive(:add_ancestor).with(ancestor_example)
      para.add_ancestors(ancestor_example)
    end

    it 'raises an error if unsupported ancestor type given' do
      random_string = 'blah'
      expect do
        para.add_ancestors(random_string)
      end.to raise_error("Unsupported ancestor type `#{random_string.class}`")
    end
  end

  describe '#add_ancestor' do
    it 'adds one ancestor to an element' do
      example_key = 'div[data-type="example"]'
      para.add_ancestor(Kitchen::Ancestor.new(example))
      expect(para.ancestors[example_key].type).to eq example_key
    end

    it 'raises an error if there is already an ancestor with the given ancestors type' do
      para = book.chapters.pages.examples.search('p').first!
      example_copy = para.ancestors['example'].element
      type = :example
      expect do
        para.add_ancestor(Kitchen::Ancestor.new(example_copy))
      end.to raise_error("Trying to add an ancestor of type '#{type}' but one of that " \
        "type is already present")
    end
  end

  describe '#ancestor_elements' do
    context 'when the element has no ancestors' do
      it 'returns an empty array' do
        expect(book.ancestor_elements).to eq []
      end
    end

    context 'when the element has ancestors' do
      it 'returns the elements in all of the ancestors' do
        expect(para.ancestor_elements).to eq Array(book)
      end
    end
  end

  describe '#search_with' do
    it 'returns elements in the right order' do
      result = searchable_book.search_with(Kitchen::PageElementEnumerator, Kitchen::ExampleElementEnumerator)
      expect(result.map(&:id)).to eq %w[page1 example1 page2]
    end
  end

  describe '#prepend' do
    sibling = '<div>Sibling</div>'
    child = '<div>Child</div>'

    it 'raises a RecipeError when a child and sibling are specified' do
      expect do
        para.prepend(child: child, sibling: sibling)
      end.to raise_error(
        Kitchen::RecipeError, 'Only one of `child` or `sibling` can be specified'
      )
    end

    it 'raises a RecipeError when neither a child and sibling are specified' do
      expect do
        para.prepend
      end.to raise_error(
        Kitchen::RecipeError, 'One of `child` or `sibling` must be specified'
      )
    end

    context 'when child argument is given' do
      it 'prepends child before the element\'s current children' do
        para.prepend(child: child)
        expect(para.children.to_s).to eq '<div>Child</div>This is a paragraph.'
      end
    end

    context 'when sibling argument is given' do
      it 'prepends as a sibling to the element' do
        para.prepend(sibling: sibling)
        expect(example.children.to_s).to match_normalized_html(
          <<~HTML
            <div>Sibling</div>
            <p>This is a paragraph.</p>
          HTML
        )
      end
    end
  end

  describe '#append' do
    sibling = '<div>Sibling</div>'
    child = '<div>Child</div>'

    it 'raises a RecipeError when a child and sibling are specified' do
      expect do
        para.append(child: child, sibling: sibling)
      end.to raise_error(
        Kitchen::RecipeError, 'Only one of `child` or `sibling` can be specified'
      )
    end

    it 'raises a RecipeError when neither a child and sibling are specified' do
      expect do
        para.append
      end.to raise_error(
        Kitchen::RecipeError, 'One of `child` or `sibling` must be specified'
      )
    end

    context 'when child argument is given' do
      it 'appends child after the element\'s current children' do
        para.append(child: child)
        expect(para.children.to_s).to eq 'This is a paragraph.<div>Child</div>'
      end
    end

    context 'when sibling argument is given' do
      it 'appends as a sibling to the element' do
        para.append(sibling: sibling)
        expect(example.children.to_s).to match_normalized_html(
          <<~HTML
            <p>This is a paragraph.</p>
            <div>Sibling</div>
          HTML
        )
      end
    end
  end

  describe '#content' do
    it 'gets the children matching the provided selector' do
      expect(book.content('.class1')).to match_normalized_html('<p>This is a paragraph.</p>')
    end
  end

  describe '#contains?' do
    it 'returns true if the element has a child matching the provided selector' do
      expect(book.contains?('.class1')).to eq true
    end
  end

  describe '#sub_header_name' do
    context 'when there isn\'t already a header' do
      it 'returns an h1' do
        expect(book.sub_header_name).to eq('h1')
      end
    end

    context 'when there is a header of h1 or greater already' do
      it 'returns the header one level lower' do
        expect(header_book.sub_header_name).to eq('h2')
      end
    end
  end
end
