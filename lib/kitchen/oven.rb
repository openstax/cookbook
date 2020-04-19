module Kitchen
  class Oven

    def self.bake(input_file:, recipes:, output_file:)
      doc = File.open(input_file) {|f| Nokogiri::XML(f)}
      [recipes].flatten.each do |recipe|
        recipe.node = doc
        recipe.bake
      end
      File.open(output_file, "w") {|f| f.write doc.to_xhtml(indent:2)}
    end

  end
end
