# frozen_string_literal: true

require 'digest'
require 'tempfile'

RSpec::Matchers.define(:be_same_file_as) do |expected_file_path|
  match do |actual_file_path|
    expect(md5_hash(actual_file_path)).to eq(md5_hash(expected_file_path))
  end

  def md5_hash(file_path)
    Digest::MD5.hexdigest(File.read(file_path))
  end
end

RSpec::Matchers.define :bake_correctly do
  match do |book|
    actual_file = Tempfile.new(book)
    `./bake -b #{book} -i spec/books/#{book}/input.xhtml -o #{actual_file.path}`
    expect("spec/books/#{book}/expected_output.xhtml").to be_same_file_as(actual_file.path)
  end
end
