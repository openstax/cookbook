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

RSpec::Matchers.define :bake_correctly_with do |recipe, resource_path|
  match do |book|
    actual_file = Tempfile.new(book)

    cmd = "#{__dir__}/../../../bake -b #{recipe} -i #{__dir__}/../books/#{book}/input.xhtml \
          -r #{__dir__}/#{resource_path} -o #{actual_file.path}"

    `#{cmd}`

    `ruby scripts/normalize #{actual_file.path}`
    normalized_path = "#{actual_file.path}.normalized"
    FileUtils.cp(normalized_path, "spec/recipes_spec/books/#{book}/actual_output.xhtml")
    expect("spec/recipes_spec/books/#{book}/expected_output.xhtml").to be_same_file_as(normalized_path)

    File.delete(normalized_path)
    File.delete("spec/recipes_spec/books/#{book}/actual_output.xhtml")
  end
end

RSpec::Matchers.define :bake_correctly do
  match do |book|
    expect(book).to bake_correctly_with(book, nil)
  end
end

RSpec::Matchers.define :bake_correctly_with_empty_resources do
  match do |book|
    expect {
      expect(book).to bake_correctly
    }.to output(/Could not find resource for image/).to_stderr_from_any_process
  end

  failure_message do |book|
    "Expected '#{book}' to bake correctly without resources.
    Either something went wrong during baking, or the resources not found warning was not recieved."
  end
end

RSpec::Matchers.define :bake_correctly_with_empty_resources_and_use do |recipe|
  match do |book|
    expect {
      expect(book).to bake_correctly_with(recipe)
    }.to output(/Could not find resource for image/).to_stderr_from_any_process
  end

  failure_message do |book|
    "Expected '#{book}' to bake correctly without resources.
    Either something went wrong during baking, or the resources not found warning was not recieved."
  end
end
