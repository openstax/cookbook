# https://makandracards.com/makandra/9185-ruby-natural-sort-strings-with-umlauts-and-other-funny-characters
# MIT Licensed

module Enumerable

  def natural_sort
    natural_sort_by
  end

  def natural_sort_by(&stringifier)
    sort_by do |element|
      element = stringifier.call(element) if stringifier
      element = element.to_s unless element.respond_to?(:to_sort_atoms)
      element.to_sort_atoms
    end
  end

end
