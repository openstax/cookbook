require "bundler/setup"
require "kitchen"

require "byebug"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :match_html do |expected|
  match do |actual|
    @actual = Nokogiri::XML(actual.to_s){|config| config.noblanks}.to_xhtml(indent: 2)
    @expected = Nokogiri::XML(expected.to_s){|config| config.noblanks}.to_xhtml(indent: 2)
    @actual == @expected
  end

  diffable
  attr_reader :actual, :expected
end

def book_containing(html)
  Kitchen::BookDocument.new(document: Nokogiri::XML(
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
