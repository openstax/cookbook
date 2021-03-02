# frozen_string_literal: true

# Monkey patches for +Object+
#
class Object

  # Adds a `render` method to a class for rendering an ERB template to a string.
  #
  # @param dir [String] a directory in which to find the template to be rendered,
  #   populated with a guess from the call stack if not provided.
  def self.renderable(dir: nil)
    dir ||= begin
      this_patch_file = __FILE__
      this_patch_file_caller_index = caller_locations.find_index do |location|
        location.absolute_path == this_patch_file
      end

      location_that_called_renderable = caller_locations[(this_patch_file_caller_index || -1) + 1]
      File.dirname(location_that_called_renderable.path)
    end

    class_eval <<~METHOD, __FILE__, __LINE__ + 1
      def renderable_base_dir
        "#{dir}"
      end
    METHOD

    class_eval do
      def render(file:)
        file = File.absolute_path(file, renderable_base_dir)
        template = File.open(file, 'rb', &:read)
        ERB.new(template).result(binding)
      end
    end
  end

end
