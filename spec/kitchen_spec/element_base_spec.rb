# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::ElementBase do

  let(:book) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="example" class="class1" id="div1" data-sm="/module/m240/filename.cnxml:13:69">
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

  let(:searchable_book_with_units) do
    book_containing(html:
      <<~HTML
        <div data-type="unit">
          <div data-type="chapter">
            <div data-type="page" id="page1">
              <div data-type="example" class="class1" id="example1">
                <p>This is an example.</p>
              </div>
              <figure id="figure1">can't touch this (stop! hammer time)</figure>
            </div>
            <div data-type="page" id="page2"> This is a page </div>
          </div>
        </div>
        <div data-type="unit">
          <div data-type="chapter">
            <div data-type="page" id="page3">
              <div data-type="example" class="class1" id="example2">
                <p>This is an example.</p>
              </div>
              <figure id="figure2">can't touch this (stop! hammer time)</figure>
            </div>
            <div data-type="page" id="page4"> This is a page </div>
          </div>
          <div data-type="chapter">
            <div data-type="page" id="page4">
              <div data-type="example" class="class1" id="example3">
                <p>This is an example.</p>
              </div>
              <figure id="figure3">can't touch this (stop! hammer time)</figure>
            </div>
            <div data-type="page" id="page5"> This is a page </div>
          </div>
        </div>
      HTML
    )
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

  describe '#data_sm' do
    it 'returns the element\'s data-sm' do
      expect(example.data_sm).to eq '/module/m240/filename.cnxml:13:69'
    end
  end

  describe '#data_source' do
    it 'returns the element\'s data source in /module/m240/filename.cnxml:13:69 format when the element has a data-sm' do
      expect(example.data_source).to eq '(self) /module/m240/filename.cnxml:13:69'
    end

    it 'returns the element\'s parent\'s data source in /module/m240/filename.cnxml:13:69 format when the element has no data-sm' do
      expect(para.data_source).to eq '(nearest parent) /module/m240/filename.cnxml:13:69'
    end

    it 'returns nil when no ancestor has a data-sm' do
      expect(figure.data_source).to eq nil
    end
  end

  describe '#say_source_or_nil' do
    it 'returns the data source in an error friendly format if it exists' do
      expect(example.say_source_or_nil).to eq "\nCNXML SOURCE: (self) /module/m240/filename.cnxml:13:69"
    end

    it 'returns nil when no data-source' do
      expect(figure.say_source_or_nil).to eq ''
    end
  end

  describe '#parent' do
    it 'returns the element\'s parent' do
      expect(para.parent).to match_normalized_html(
        <<~HTML
          <div class="class1" data-sm="/module/m240/filename.cnxml:13:69" data-type="example" id="div1">
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
      end.to raise_error("No ancestor of type '#{type}'\nCNXML SOURCE: (nearest parent) /module/m240/filename.cnxml:13:69")
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
        "type is already present\nCNXML SOURCE: (nearest parent) /module/m240/filename.cnxml:13:69")
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

  describe '#contains_blockish?' do
    it 'returns true if the element has a blockish descendant (div)' do
      expect(blank_space_book.contains_blockish?).to eq true
    end

    it 'returns false if the element only contians inline descendants (span)' do
      expect(blank_space_book.first!('h1').contains_blockish?).to eq false
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

  describe '#os_number' do
    it 'works with chapter numbers' do
      options = { separator: '.', mode: :chapter_page }
      numbers = searchable_book_with_units.units.chapters.pages.map do |page|
        page.os_number(options)
      end
      expect(numbers.to_a).to eq [
        '1.1',
        '1.2',
        '2.1',
        '2.2',
        '3.1',
        '3.2'
      ]
    end

    it 'works with unit numbers' do
      options = { separator: '-', mode: :unit_chapter_page }
      numbers = searchable_book_with_units.units.chapters.pages.map do |page|
        page.os_number(options)
      end
      expect(numbers.to_a).to eq [
        '1-1-1',
        '1-1-2',
        '2-1-1',
        '2-1-2',
        '2-2-1',
        '2-2-2'
      ]
    end
  end

  describe '#number_parts' do
    it 'works with chapter numbers' do
      parts = searchable_book_with_units.units.chapters.pages.map do |page|
        page.number_parts(:chapter_page,
                          unit_offset: 0,
                          chapter_offset: 0,
                          page_offset: 0)
      end
      expect(parts.to_a).to eq [
        [1, 1],
        [1, 2],
        [2, 1],
        [2, 2],
        [3, 1],
        [3, 2]
      ]
    end

    it 'works with unit numbers' do
      unit_parts = searchable_book_with_units.units.map do |unit|
        unit.number_parts(:unit_chapter_page,
                          unit_offset: 0,
                          chapter_offset: 0,
                          page_offset: 0)
      end
      chapter_parts = searchable_book_with_units.units.chapters.map do |unit|
        unit.number_parts(:unit_chapter_page,
                          unit_offset: 0,
                          chapter_offset: 0,
                          page_offset: 0)
      end
      page_parts = searchable_book_with_units.units.chapters.pages.map do |page|
        page.number_parts(:unit_chapter_page,
                          unit_offset: 0,
                          chapter_offset: 0,
                          page_offset: 0)
      end
      expect(unit_parts).to eq [[1], [2]]
      expect(chapter_parts).to eq [[1, 1], [2, 1], [2, 2]]
      expect(page_parts).to eq [
        [1, 1, 1],
        [1, 1, 2],
        [2, 1, 1],
        [2, 1, 2],
        [2, 2, 1],
        [2, 2, 2]
      ]
    end

    it 'errors when mode is unknown' do
      expect do
        searchable_book_with_units.units.chapters.pages.map do |page|
          page.number_parts(:the_unknown_soldier,
                            unit_offset: 0,
                            chapter_offset: 0,
                            page_offset: 0)
        end
      end.to raise_error(/Unknown mode: the_unknown_soldier/)
    end
  end

  describe '#add_platform_media' do
    let(:no_media) do
      book_containing(html:
        <<~HTML
          <div>
            <span>book only content</span>
          </div>
        HTML
      ).first('span')
    end

    let(:some_media) do
      book_containing(html:
        <<~HTML
          <div>
            <span data-media="screen">already has media attribute</span>
          </div>
        HTML
      ).first('span')
    end

    it 'adds media when no preexisting media' do
      no_media.add_platform_media('print')
      expect(no_media[:'data-media']).to eq('print')
    end

    it 'adds media when some media is there' do
      some_media.add_platform_media('print')
      expect(some_media[:'data-media']).to eq('screen print')
    end

    it 'doesn\'t add media twice' do
      some_media.add_platform_media('screen')
      expect(some_media[:'data-media']).to eq('screen')
    end

    it 'throws when given invalid output' do
      expect do
        some_media.add_platform_media('metaverse')
      end.to raise_error('Media format invalid; valid formats are ["screen", "print", "screenreader"]') # TODO: specify exception
    end
  end

  describe '#clone' do
    context 'when node has a namespace' do
      let(:book_with_namespaces) do
        book_containing(html:
          <<~HTML
            <div data-type="chapter">
              <m:math/>
              <math xmlns="http://www.w3.org/1998/Math/MathML"></math>
            <div>
          HTML
        )
      end

      it 'preserves namespaces when cloning (like m:math)' do
        expect(book_with_namespaces.clone).to match_snapshot_auto
      end
    end

    context 'when node attribute has a namespace' do
      # `book_containing` method is creating new document (see factory_helpers.rb)
      # When document is initialized then all namespaces definitions are collected
      # and added to html tag (see document.rb)
      #
      # To be able to test case when node being cloned doesn't have an ancestor
      # with namespace definition, we need to add an element to existing document,
      # so then namespaces from this node won't be collected to html tag.
      let(:chapter) do
        <<~HTML
          <div data-type="chapter">
            <span xmlns:epub="http://example.com/epub" epub:attr="abc"/>
          <div>
        HTML
      end

      let(:new_book) do
        book_containing(html:
          <<~HTML
          HTML
        )
      end

      before do
        new_book.search('body').first.replace_children(with: chapter)
      end

      it 'preserves attributes namespaces when cloning (like footnote epub:type)' do
        expect(new_book.clone).to match_snapshot_auto
      end
    end
  end
end
