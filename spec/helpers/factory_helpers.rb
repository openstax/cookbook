module FactoryHelpers

  def book_containing(short_name: :not_set, html:)
    Kitchen::BookDocument.new(short_name: short_name, document: Nokogiri::XML(
      <<~HTML
        <html>
          <body>
            #{html}
          </body>
        </html>
      HTML
    )).book
  end

  def one_chapter_with_one_page_containing(html)
    <<~HTML
      <div data-type="chapter">
        <div data-type="page">
          #{html}
        </div>
      </div>
    HTML
  end

  def new_element(html)
    nokogiri_document = Nokogiri::XML(
      <<~HTML
        <html>
          <body>
            #{html}
          </body>
        </html>
      HTML
    )

    children = nokogiri_document.search("body").first.element_children
    raise("new_element must only make one top-level element") if children.many?
    node = children.first

    Kitchen::Element.new(node: node, document: nokogiri_document)
  end

end
