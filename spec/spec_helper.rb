require "bundler/setup"
require "kitchen"

require "byebug"
require "nokogiri/diff"
require "rainbow"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :match_html_strict do |expected|
  match do |actual|
    @actual = Nokogiri::XML(actual.to_s){|config| config.noblanks}.to_xhtml(indent: 2)
    @expected = Nokogiri::XML(expected.to_s){|config| config.noblanks}.to_xhtml(indent: 2)
    @actual == @expected
  end

  diffable
  attr_reader :actual, :expected
end

RSpec::Matchers.define :match_html do |expected|
  match do |actual|
    @actual = normalized_xml_doc(actual)
    @expected = normalized_xml_doc(expected)
    @actual.diff(@expected).all?{|change, _| change.blank?}
  end

  failure_message do |actual|
    @actual = normalized_xml_doc(actual)
    @expected = normalized_xml_doc(expected)

    diff_lines = @actual.diff(@expected).map do |change,node|
      reduced_node = node.dup
      reduced_node.children = "..."
      # debugger if !change.blank?
      "#{change} #{reduced_node.to_xhtml}".ljust(30) if !change.blank?
    end.compact

    <<~MSG
      #{colorize("expected that actual:", :yellow)}

      #{colorize(@actual, :white)}

      #{colorize("would match expected:", :yellow)}

      #{colorize(@expected, :white)}

      #{colorize("Diff:", :yellow)}

      #{diff_lines.map{|line| colorize(line, line[0] == "+" ? :green : :red)}.join("\n")}
    MSG
  end
end

def colorize(stringable, color)
  stringable.to_s.split("\n").map{|line| Rainbow(line).send(color)}.join("\n")
end

def normalized_xml_doc(xml_thing_with_to_s)
  Nokogiri::XML(
    Nokogiri::XML(xml_thing_with_to_s.to_s) do |config|
      config.noblanks
    end.to_xhtml(indent: 2)
  ) do |config|
    config.noblanks
  end.tap(&:remove_namespaces!)
end

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

def stub_locales(hash)
  I18n.config.available_locales = [:test, :en]
  allow_any_instance_of(I18n::Config).to receive(:backend).and_return(
    I18n::Backend::Simple.new.tap do |backend|
      backend.store_translations 'test', hash
    end
  )
  allow_any_instance_of(I18n::Config).to receive(:locale).and_return(:test)
end
