require "kitchen/version"

require "nokogiri"

module Kitchen
end

require "kitchen/errors"
require "kitchen/selector"
require "kitchen/debug/print_recipe_error"
require "kitchen/generators/container"
require "kitchen/generators/sub_header"
require "kitchen/recipe"
require "kitchen/oven"
require "kitchen/clipboard"
require "kitchen/step"
require "kitchen/steps/basic"
require "kitchen/steps/each"
require "kitchen/steps/first"
require "kitchen/steps/cut"
require "kitchen/steps/copy"
require "kitchen/steps/append_child"
