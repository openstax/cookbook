# frozen_string_literal: true

module Kitchen
  # A class for baking documents according to the instructions in recipes
  #
  class Oven

    # Bakes an input file using a recipe to produce an output file
    #
    # @param input_file [String] the path to the input file
    # @param config_file [String] the path to the configuration file
    # @param recipes [Array<Recipe>] an array of recipes with which to bake the document
    # @param output_file [String] the path to the output file
    #
    def self.bake(input_file:, recipes:, output_file:, config_file: nil, resource_dir: nil)
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

      # Add image metadata to resource hash
      resources = {}
      if resource_dir
        Dir.foreach(resource_dir) do |filename|
          next unless filename.match(/.json/)

          file = File.read("#{resource_dir}/#{filename}")
          img_hash = JSON.parse(file).with_indifferent_access
          img_src = filename.gsub('.json', '').to_sym
          resources[img_src] = img_hash
        end
      end

      I18n.locale = doc.locale

      [recipes].flatten.each do |recipe|
        recipe.document = doc
        recipe.resources = resources
        recipe.bake
      end
      profile.baked!

      File.open(output_file, 'w') do |f|
        f.write doc.to_xhtml(indent: 2, encoding: doc.encoding || 'utf-8')
      end
      profile.written!

      Nokogiri::XML.print_profile_data if ENV['PROFILE'] && !ENV['TESTING']

      profile
    end

    # Stats on baking
    #
    class BakeProfile
      # Record that baking has started
      def started!; @started_at = Time.now; end

      # Record that the input file has been opened
      def opened!;  @opened_at = Time.now;  end

      # Record that the input file has been parsed
      def parsed!;  @parsed_at = Time.now;  end

      # Record that the input file has been baked
      def baked!;   @baked_at = Time.now;   end

      # Record that the output file has been written
      def written!; @written_at = Time.now; end

      # Return the number of seconds it took to open the input file or nil if this
      # info isn't available.
      # @return [Float, nil]
      def open_seconds
        @opened_at - @started_at
      rescue NoMethodError
        nil
      end

      # Return the number of seconds it took to parse the input file after opening or
      # nil if this info isn't available.
      # @return [Float, nil]
      def parse_seconds
        @parsed_at - @opened_at
      rescue NoMethodError
        nil
      end

      # Return the number of seconds it took to bake the parsed file or nil if this
      # info isn't available.
      # @return [Float, nil]
      def bake_seconds
        @baked_at - @parsed_at
      rescue NoMethodError
        nil
      end

      # Return the number of seconds it took to write the baked file or nil if this
      # info isn't available.
      # @return [Float, nil]
      def write_seconds
        @written_at - @baked_at
      rescue NoMethodError
        nil
      end

      # Return the profile stats as a string
      # @return [String]
      def to_s
        <<~STRING
          Open:  #{open_seconds || '??'} s
          Parse: #{parse_seconds || '??'} s
          Bake:  #{bake_seconds || '??'} s
          Write: #{write_seconds || '??'} s
        STRING
      end
    end

  end
end
