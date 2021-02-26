# frozen_string_literal: true

require 'spec_helper'

books = ['dummy'] # add finished books to this array

RSpec.describe 'books' do
  before(:all) do
    books.each do |book|
      # call the bake script for each book
      output = `USE_LOCAL_KITCHEN=1 ./bake -b #{book} -i spec/books/#{book}/input.xhtml \
        -o spec/books/#{book}/actual_output.xhtml`
      puts output
    end
  end

  books.each do |book|
    it "#{book} matches expected output" do
      expect("spec/books/#{book}/expected_output.xhtml").to be_same_file_as(
        "spec/books/#{book}/actual_output.xhtml"
      )
    end
  end
end
