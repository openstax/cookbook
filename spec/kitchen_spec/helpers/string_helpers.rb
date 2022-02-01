# frozen_string_literal: true

module StringHelpers
  def with_captured_stdout(clear_colors: false)
    original_stdout = $stdout   # capture previous value of $stdout
    $stdout = StringIO.new      # assign a string buffer to $stdout
    yield                       # perform the body of the user code

    # return the captured string
    if clear_colors
      $stdout.string.gsub(/\e\[(\d+)(;\d+)*m/, '')
    else
      $stdout.string
    end
  ensure
    $stdout = original_stdout # restore $stdout to its previous value
  end
end
