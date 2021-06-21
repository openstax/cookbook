# frozen_string_literal: true

# Monkey patches for +Array+
#
class Array

  # Receives a string to add as prefix in each item and returns
  # a new array with the concatenaded strings
  #
  # @return [Array<String>]
  #
  def prefix(string)
    map { |item| "#{string}#{item}" }
  end
end
