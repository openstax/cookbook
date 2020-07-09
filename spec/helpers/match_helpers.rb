module MatchHelpers

  RSpec::Matchers.define :match_html_strict do |expected|
    match do |actual|
      @actual = Nokogiri::XML(actual.to_s){|config| config.noblanks}.to_xhtml(indent: 2)
      @expected = Nokogiri::XML(expected.to_s){|config| config.noblanks}.to_xhtml(indent: 2)
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

  RSpec::Matchers.define :match_html_nodes do |expected|
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

  def normalized_xml_doc_string(xml_thing_with_to_s)
    # in case xml_thing_with_to_s is several top level elements, wrap it
    # in a dummy element and extract it back out below

    xml_thing_with_to_s = "<dummy>#{xml_thing_with_to_s}</dummy>"
    doc = Nokogiri::XML(xml_thing_with_to_s.to_s) do |config|
      config.noblanks
    end

    doc.alphabetize_attributes!

    doc.search("dummy").children.to_xhtml(indent: 2)
  end

end
