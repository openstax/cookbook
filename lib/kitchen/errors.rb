require 'rainbow'

module Kitchen
  class RecipeError < StandardError
    EXTRA_LINES = 2

    def print(source_location:)
      error_location = backtrace.detect do |entry|
        entry.start_with?(source_location)
      end

      error_filename, error_line_number = error_location.match(/(.*):(\d+):/)[1..2]
      error_line_number = error_line_number.to_i

      puts "The recipe has an error: " + Rainbow(message).bright
      puts "at or near the following #{Rainbow('highlighted').red} line"
      puts "\n"
      puts "----- #{Rainbow(error_filename).bright} -----"

      line_numbers_before = (error_line_number-EXTRA_LINES..error_line_number-1)
      line_numbers_after  = (error_line_number+1..error_line_number+EXTRA_LINES)

      File.readlines(error_filename).each.with_index do |line, line_index|
        line_number = line_index + 1

        if line_numbers_before.include?(line_number) ||
           line_numbers_after.include?(line_number)
          print_file_line(line_number, line)
        end

        if line_number == error_line_number
          print_file_line(line_number, Rainbow(line.chomp).red)
        end
      end
    end

    protected

    def print_file_line(line_number, line)
      puts "#{"%5s" % line_number}: #{line}"
    end
  end
end
