module Kitchen
  class Oven

    def self.bake(input_file:,
                  config_file: nil,
                  recipes:,
                  output_file:)

      profile = BakeProfile.new
      profile.started!

      nokogiri_doc = File.open(input_file) do |f|
        profile.opened!
        Nokogiri::XML(f).tap { profile.parsed! }
      end

      config = config_file.nil? ? nil : Config.new_from_file(File.open(config_file))

      doc = Kitchen::Document.new(
        nokogiri_document: nokogiri_doc,
        config: config
      )

      [recipes].flatten.each do |recipe|
        recipe.document = doc
        recipe.bake
      end
      profile.baked!

      File.open(output_file, "w") do |f|
        f.write doc.to_xhtml(indent:2)
      end
      profile.written!

      profile
    end

    class BakeProfile
      def started!; @started_at = Time.now; end
      def opened!;  @opened_at = Time.now;  end
      def parsed!;  @parsed_at = Time.now;  end
      def baked!;   @baked_at = Time.now;   end
      def written!; @written_at = Time.now; end

      def open_seconds;  @opened_at  - @started_at; end
      def parse_seconds; @parsed_at  - @opened_at;  end
      def bake_seconds;  @baked_at   - @parsed_at;  end
      def write_seconds; @written_at - @baked_at;   end

      def to_s
        <<~STRING
          Open:  #{open_seconds} s
          Parse: #{parse_seconds} s
          Bake:  #{bake_seconds} s
          Write: #{write_seconds} s
        STRING
      end
    end

  end
end
