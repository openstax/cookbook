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

  let(:book_with_link) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="example" class="class1" id="div1">
            <p>This is a paragraph.</p>
            <a href="div1">This is a link.</a>
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

  let(:title_book) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="example" class="class1" id="div1">
            <p>This is a paragraph.</p>
          </div>
          <div data-type="title">Div Title</div>
          <span data-type="title">Span Title</span>
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

  let(:sibling_book) do
    book_containing(html:
      chapter_element(
        <<~HTML
          <div data-type="page" id="page1">
            <p>Some text</p>
            <div data-type="example" class="class1" id="example1">
              <p>This is an example.</p>
            </div>
            <figure id="figure1">Who is my closest sibling?</figure>
            <p>
              <div data-type="note">Reference 1</div>
              Some other Text
              <div data-type="note" class="reference">Reference 2</div>
            </p>
          </div>
        HTML
      )
    )
  end

  let(:blank_space_book) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title" id="chapTitle1">
            <span class="os-part-text">Chapter </span>
            <span class="os-number">1</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
          </h1>
          <div data-type="page">
            #{metadata_element}
            <div class="parent">

              <div data-type="note">Reference 1</div>
              "Some Text"

              <div class="text-above">Reference 1</div>
            </div>
          </div>
        <div>
      HTML
    )
  end

  let(:example) { book.first!('div[data-type="example"]') }

  let(:para) { book.first!('p') }

  let(:link) { book_with_link.first!('a') }

  let(:figure) { sibling_book.first!('figure') }

  let(:reference) { sibling_book.first!('div.reference') }

  let(:note) { blank_space_book.first!('div[data-type="note"]') }

  let(:text_above) { blank_space_book.first!('div.text-above') }

  describe '#initialize' do
    it 'explodes if given a bad document type' do
      expect {
        described_class.new(node: 'foo', document: 'some string', enumerator_class: 'bar')
      }.to raise_error(/not a known document type/)
    end
  end

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

  describe '#href' do
    it 'returns the element\'s href' do
      expect(link.href).to eq 'div1'
    end
  end

  describe '#href=' do
    it 'sets the element\'s href' do
      link.href = 'para1'
      expect(link.href).to eq 'para1'
    end
  end

  describe '#parent' do
    it 'returns the element\'s parent' do
      expect(para.parent).to match_normalized_html(
        <<~HTML
          <div class="class1" data-type="example" id="div1">
            <p>This is a paragraph.</p>
          </div>
        HTML
      )
    end
  end

  describe '#previous' do
    it 'returns the element\'s immediately previous sibling' do
      expect(figure.previous).to match_normalized_html(
        <<~HTML
          <div data-type="example" class="class1" id="example1">
            <p>This is an example.</p>
          </div>
        HTML
      )
    end

    it 'skips text belonging to a parent element' do
      expect(reference.previous).to match_normalized_html(
        <<~HTML
          <div data-type="note">Reference 1</div>
        HTML
      )
    end

    it 'returns nil when a previous sibling does not exist' do
      expect(para.previous).to eq nil
    end
  end

  describe '#preceded_by_text?' do
    it 'returns true if preceded by text' do
      expect(reference.preceded_by_text?).to eq true
    end

    it 'returns false if no previous siblings' do
      expect(example.preceded_by_text?).to eq false
    end

    it 'returns false if previous sibling is an element' do
      expect(figure.preceded_by_text?).to eq false
    end

    it 'returns false if no previous siblings except blank space' do
      expect(note.preceded_by_text?).to eq false
    end

    it 'returns true if preceded by blank space and then text' do
      expect(text_above.preceded_by_text?).to eq true
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

    it 'adds an element as an ancestor' do
      expect(para).to receive(:add_ancestor).with(kind_of(Kitchen::Ancestor))
      para.add_ancestors(example)
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
    let(:sibling) { '<div>Sibling</div>' }
    let(:child) { '<div>Child</div>' }

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

    context 'when the element has no children' do
      it 'prepends a child' do
        childless = new_element('<div/>')
        childless.prepend(child: '<span>foo</span>')
        expect(childless.children.to_s).to eq '<span>foo</span>'
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

    context 'when the element has no children' do
      it 'appends a child' do
        childless = new_element('<div/>')
        childless.append(child: '<span>foo</span>')
        expect(childless.children.to_s).to eq '<span>foo</span>'
      end
    end
  end

  describe '#wrap_children' do
    let(:element) { new_element('<div>something <i>awesome</i></div>') }

    it 'wraps with no arguments' do
      expect(element.wrap_children).to match_normalized_html(
        '<div><div>something <i>awesome</i></div></div>'
      )
    end

    it 'can set attributes on the wrapper' do
      expect(element.wrap_children(class: 'foo')).to match_normalized_html(
        '<div><div class="foo">something <i>awesome</i></div></div>'
      )
    end

    it 'works with a different name' do
      expect(element.wrap_children('span')).to match_normalized_html(
        '<div><span>something <i>awesome</i></span></div>'
      )
    end

    it 'accepts a block to do extra work on the wrapper' do
      element.wrap_children(class: 'outer') do |wrapper|
        wrapper.wrap_children(class: 'inner')
      end

      expect(element).to match_normalized_html(
        '<div><div class="outer"><div class="inner">something <i>awesome</i></div></div></div>'
      )
    end

    it 'returns self for chaining' do
      element.wrap_children.add_class('foo')
      expect(element).to match_normalized_html(
        '<div class="foo"><div>something <i>awesome</i></div></div>'
      )
    end

    it 'converts underscores to dashes in attribute keys' do
      expect(element.wrap_children(data_type: 'foo')).to match_normalized_html(
        '<div><div data-type="foo">something <i>awesome</i></div></div>'
      )
    end

    it 'converts double underscores to single underscores in attribute keys' do
      expect(element.wrap_children(data__type: 'foo')).to match_normalized_html(
        '<div><div data_type="foo">something <i>awesome</i></div></div>'
      )
    end

    context 'when a search finds nested elements and we use wrap_children' do
      let(:element) { new_element('<outer><div class="bar">something <div class="bar">internal</div></div></outer>') }

      it 'maintains the document structure so that iteration to nested elements still works' do
        element.search('div.bar').each do |match|
          match.add_class('foo')
          match.wrap_children('div')
        end

        expect(element).to match_normalized_html(
          '<outer><div class="bar foo"><div>something <div class="bar foo"><div>internal</div></div></div></div></outer>'
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

  describe '#titles' do
    it 'returns elements with data-type title' do
      expect(title_book.titles.map(&:text)).to eq(['Div Title', 'Span Title'])
    end

    context 'when just divs are specified' do
      it 'returns just divs' do
        expect(title_book.titles('div$').map(&:text)).to eq(['Div Title'])
      end
    end

    context 'when just spans are specified' do
      it 'returns just spans' do
        expect(title_book.titles('span$').map(&:text)).to eq(['Span Title'])
      end
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

  describe '#get_clipboard' do
    it 'explodes when the argument is not a clipboard or symbol' do
      expect { book.send(:get_clipboard, 'foo') }.to raise_error(/is not a clipboard name or a clipboard/)
    end
  end

  describe '#inspect' do
    it 'calls to_s' do
      expect(book).to receive(:to_s)
      book.inspect
    end
  end

  describe '#to_xml' do
    it 'delegates to the node' do
      expect(book.raw).to receive(:to_xml)
      book.to_xml
    end
  end

  describe '#to_xhtml' do
    it 'delegates to the node' do
      expect(book.raw).to receive(:to_xhtml)
      book.to_xhtml
    end
  end

  describe '#to_s' do
    it 'delegates to the node' do
      expect(book.raw).to receive(:to_s)
      book.to_s
    end
  end

  describe '#count_in' do
    it 'raises when asked for counts in a non-existent ancestor' do
      expect { para.count_in(:foo) }.to raise_error(/No ancestor/)
    end
  end
end
