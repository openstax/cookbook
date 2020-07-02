module Kitchen
  module Mixins
    module BlockErrorIf

      def block_error_if(block_given)
        calling_method = begin
          this_method_location_index = caller_locations.find_index do |location|
            location.label == "block_error_if"
          end

          caller_locations[(this_method_location_index || -1) + 1].label
        end

        raise(RecipeError, "The `#{calling_method}` method does not take a block argument") if block_given
      end

    end
  end
end
