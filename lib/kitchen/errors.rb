# frozen_string_literal: true
module Kitchen
  # Raised likely due to a problem in the recipe, not in Kitchen
  class RecipeError < StandardError; end

  # Raised when an element not found
  class ElementNotFoundError < StandardError; end
end
