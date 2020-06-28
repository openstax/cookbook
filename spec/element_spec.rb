require 'spec_helper'

RSpec.describe Kitchen::Element do

  let(:element_1) do
    new_element(
      <<~HTML
        <div id="divId" class="class1 class2" data-type="a-div">
          <p id="pId">Hi there</p>
        </div>
      HTML
    )
  end

  it "can get the name" do
    expect(element_1.name).to eq "div"
  end

  it "can set the name" do
    element_1.name = "h2"
    expect(element_1.to_s).to start_with("<h2")
  end

  it "can get an arbitrary attribute" do
    expect(element_1["data-type"]).to eq "a-div"
  end

  it "can set an arbitrary attribute" do
    element_1["some_attr"] = "hi"
    expect(element_1.to_s).to match(/div.*some_attr="hi"/)
  end

  it "can remove an arbitrary attribute" do
    element_1.remove_attribute("data-type")
    expect(element_1.to_s).not_to match(/some_attr/)
  end

  it "can add a class" do
    element_1.add_class("new_class")
    expect(element_1.to_s).to match(/class="class1 class2 new_class"/)
  end

  it "can remove a class" do
    element_1.remove_class("class1")
    expect(element_1.to_s).to match(/class="class2"/)
  end

  it "can say if has a class" do
    expect(element_1.has_class?("class2")).to eq true
  end

  it "can return an array of classes" do
    expect(element_1.classes).to contain_exactly("class1", "class2")
  end

  it "can get the ID" do
    expect(element_1.id).to eq "divId"
  end

  it "can set the ID" do
    element_1.id = "blah"
    expect(element_1.to_s).to match(/<div id="blah"/)
  end

  it "can get the text contents" do
    expect(element_1.text).to match /\n.*Hi there\n/
  end

  it "can wrap itself" do
    element_1.wrap("<div id='outer'>")
    expect(element_1.raw.parent[:id]).to eq "outer"
  end

  xit "can return its children" do

  end

  it "can be converted to an HTML string" do
    expect(element_1.to_html + "\n").to eq(
      <<~HTML
        <div id="divId" class="class1 class2" data-type="a-div">
          <p id="pId">Hi there</p>
        </div>
      HTML
    )
  end

  context "#cut" do
    before { @parent = element_1.parent }

    it "can cut to a named clipboard" do
      element_1.cut(to: :something)
      expect(@parent.to_s).not_to match(/divId/)
      expect(element_1.document.clipboard(name: :something).paste).to match(/divId/)
    end

    it "can cut to a new clipboard" do
      clipboard = element_1.cut
      expect(@parent.to_s).not_to match(/divId/)
      expect(clipboard.paste).to match(/divId/)
    end

    it "can cut to an existing clipboard" do
      clipboard = Kitchen::Clipboard.new
      element_1.cut(to: clipboard)
      expect(@parent.to_s).not_to match(/divId/)
      expect(clipboard.paste).to match(/divId/)
    end
  end

  context "#copy" do
    before { @parent = element_1.parent }

    it "can copy to a named clipboard" do
      element_1.copy(to: :something)
      expect(@parent.to_s).to match(/divId/)
      expect(element_1.document.clipboard(name: :something).paste).to match(/divId/)
    end

    it "can copy to a new clipboard" do
      clipboard = element_1.copy
      expect(@parent.to_s).to match(/divId/)
      expect(clipboard.paste).to match(/divId/)
    end

    it "can copy to an existing clipboard" do
      clipboard = Kitchen::Clipboard.new
      element_1.copy(to: clipboard)
      expect(@parent.to_s).to match(/divId/)
      expect(clipboard.paste).to match(/divId/)
    end
  end

end
