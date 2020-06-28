require 'spec_helper'

RSpec.describe Kitchen::Element do

  it "can get the name" do

  end

  it "can set the name" do

  end

  it "can get an arbitrary attribute" do

  end

  it "can set an arbitrary attribute" do

  end

  it "can remove an arbitrary attribute" do

  end

  it "can add a class" do

  end

  it "can remove a class" do

  end

  it "can say if has a class" do

  end

  it "can return an array of classes" do

  end

  it "can get the ID" do

  end

  it "can set the ID" do

  end

  it "can get the text contents" do

  end

  it "can wrap itself" do

  end

  it "can return its children" do

  end

  it "can be converted to an HTML string" do

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
