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

    cmd = `#{__dir__}/../../bake -b #{book} -i #{__dir__}/../../spec/books/#{book}/input.xhtml -o \
      #{actual_file.path}`

    if ENV['USE_LOCAL_KITCHEN']
      system({ 'USE_LOCAL_KITCHEN' => '1' }, cmd, %i[out err] => File::NULL)
    else
      cmd
    end

    `ruby scripts/normalize #{actual_file.path}`
    normalized_path = "#{actual_file.path}.normalized"

    expect("spec/books/#{book}/expected_output.xhtml").to be_same_file_as(normalized_path)

    File.delete(normalized_path)
  end
end
