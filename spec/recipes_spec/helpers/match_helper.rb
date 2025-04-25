# frozen_string_literal: true

require 'digest'

RSpec::Matchers.define(:be_same_file_as) do |expected_file_path|
  match do |actual_file_path|
    expect(md5_hash(actual_file_path)).to eq(md5_hash(expected_file_path))
  end

  def md5_hash(file_path)
    Digest::MD5.hexdigest(File.read(file_path))
  end
end

def form_bake_cmd(book:, recipe: nil, resource_path: nil, output_platform: nil)
  recipe ||= book
  "#{__dir__}/../../../bake -b #{recipe} \
  -i #{__dir__}/../books/#{book}/input.xhtml \
  #{"-r #{__dir__}/#{resource_path}" if resource_path} \
  -o #{__dir__}/../books/#{book}/actual_output.xhtml \
  -p #{output_platform || 'default'}"
end

RSpec::Matchers.define(:match_expected_when_baked_with) do |cmd|
  match do |book|
    # run formatted command with logging silenced
    system(cmd)

    # write output and run test
    actual_output = "#{__dir__}/../books/#{book}/actual_output.xhtml"
    `ruby scripts/normalize #{actual_output}`
    expect("spec/recipes_spec/books/#{book}/expected_output.xhtml").to be_same_file_as(actual_output)
    # only deletes actual_output if expect succeeds
    File.delete(actual_output)
  end
end
