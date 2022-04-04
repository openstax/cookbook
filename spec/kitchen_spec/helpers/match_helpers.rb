# frozen_string_literal: true

require 'rspec/snapshot'

# Automatically generate a snapshot filename
# Source: https://github.com/levinmr/rspec-snapshot/issues/6#issuecomment-1048145790
def match_snapshot_auto
  example = RSpec.current_example

  # get the description (name) or the scoped id (like 1:2:4:8)
  path_data = [example.metadata[:description] || example.metadata[:scoped_id]]
  parent = example.example_group

  base_path = ''
  while parent != RSpec::ExampleGroups
    base_path = File.dirname(parent.file_path.gsub('./spec/', ''))

    path_data << parent.metadata[:description]
    parent = parent.module_parent
  end

  path_data << base_path if base_path.present?

  # path_data is ['renders_component', 'when rating is > 0', 'StarRatingComponent', 'components']
  name = path_data.reverse.join('/')
  # hash = name.hash.abs.to_s[0, 5]

  # If a path component starts with Kitchen:: then remove the string before it
  index_of_kitchen = name.index('/Kitchen::')
  name = name[index_of_kitchen + 1..] unless index_of_kitchen.nil?

  sanitized = name
              .gsub(/\/$/, '')
              .gsub('/', '_')
              .gsub(/[^\w]+/, '_')
  # sanitized = "#{sanitized}.#{hash}"
  match_snapshot(sanitized)
end

# Matchers that compare HTML
module MatchHelpers
  RSpec::Matchers.define :match_html_strict do |expected|
    match do |actual|
      @actual = Nokogiri::XML(actual.to_s) { |config| config.noblanks }.to_xhtml(indent: 2)
      @expected = Nokogiri::XML(expected.to_s) { |config| config.noblanks }.to_xhtml(indent: 2)
      @actual == @expected
    end

    diffable
    attr_reader :actual, :expected
  end

  RSpec::Matchers.define :match_normalized_html do |expected|
    match do |actual|
      @actual = normalized_xml_doc_string(actual)
      @expected = normalized_xml_doc_string(expected)
      @actual == @expected
    end

    diffable
    attr_reader :actual, :expected
  end

  # Good if there are text elements with whitespace that is not important but
  # is messing up the spec diff.
  RSpec::Matchers.define :match_normalized_html_with_stripping do |expected|
    match do |actual|
      @actual = normalized_xml_doc_string(actual).split.map(&:strip).join("\n")
      @expected = normalized_xml_doc_string(expected).split.map(&:strip).join("\n")
      @actual == @expected
    end

    diffable
    attr_reader :actual, :expected
  end

  RSpec::Matchers.define :match_html_nodes do |expected|
    match do |actual|
      @actual = normalized_xml_doc(actual)
      @expected = normalized_xml_doc(expected)
      @actual.diff(@expected).all? { |change, _| change.blank? }
    end

    failure_message do |actual|
      @actual = normalized_xml_doc(actual)
      @expected = normalized_xml_doc(expected)

      diff_lines = @actual.diff(@expected).map do |change, node|
        reduced_node = node.dup
        reduced_node.children = '...'
        "#{change} #{reduced_node.to_xhtml}".ljust(30) unless change.blank?
      end.compact

      <<~MSG
        #{colorize('expected that actual:', :yellow)}

        #{colorize(@actual, :white)}

        #{colorize('would match expected:', :yellow)}

        #{colorize(@expected, :white)}

        #{colorize('Diff:', :yellow)}

        #{diff_lines.map { |line| colorize(line, line[0] == '+' ? :green : :red) }.join("\n")}
      MSG
    end
  end

  def colorize(stringable, color)
    stringable.to_s.split("\n").map { |line| Rainbow(line).send(color) }.join("\n")
  end

  def normalized_xml_doc(xml_thing_with_to_s)
    Nokogiri::XML(
      normalized_xml_doc_string(xml_thing_with_to_s)
    ) do |config|
      config.noblanks
    end.tap(&:remove_namespaces!)
  end

  # A way to standardize an XML string, useful for comparisons
  #
  # @param xml_thing_with_to_s [Object] An object that gives XML string when +to_s+ is called
  # @return [String]
  #
  def normalized_xml_doc_string(xml_thing_with_to_s)
    # in case xml_thing_with_to_s is several top level elements, wrap it
    # in a dummy element and extract it back out below

    xml_thing_with_to_s = "<dummy>#{xml_thing_with_to_s}</dummy>"
    doc = Nokogiri::XML(xml_thing_with_to_s.to_s) do |config|
      config.noblanks
    end

    doc.alphabetize_attributes!

    doc.search('dummy').children.to_xhtml(indent: 2)
  end
end
