# frozen_string_literal: true

require 'rainbow'

module Kitchen
  # Debug helpers
  module Debug
    CONTEXT_LINES = 2

    def self.print_recipe_error(error:, source_location:, document:)
      print_error_message(error)

      error_line_number, error_filename = get_error_location(error, source_location)
      print_file_line_with_context(error_line_number, error_filename)

      puts "\n"

      print_specific_help_line(error)
      print_line_in_document_where_error_occurred(document)
      print_backtrace_info(error)
    end

    def self.verbose?
      !ENV['VERBOSE'].nil?
    end

    def self.print_error_message(error)
      puts "The recipe has an error: #{Rainbow(error.message).bright}"
    end

    def self.print_backtrace_info(error)
      if verbose?
        puts "Full backtrace:\n"
        puts(error.backtrace.map { |line| Rainbow(line).blue })
      else
        puts 'Full backtrace suppressed; enable by setting the VERBOSE env variable to something'
      end
    end

    def self.print_line_in_document_where_error_occurred(document)
      current_node = document&.location&.raw
      return unless current_node

      puts "Encountered on line #{Rainbow(current_node.line).red} in the input document on element:"
      puts current_node.dup.tap { |node| node.inner_html = '...' if node.inner_html != '' }.to_s
      puts "\n"
    end

    def self.print_file_line_with_context(line_number, filename)
      puts "at or near the following #{Rainbow('highlighted').red} line"
      puts "\n"
      puts "-----+ #{Rainbow(filename).bright} -----"

      line_numbers_before = (line_number - CONTEXT_LINES..line_number - 1)
      line_numbers_after  = (line_number + 1..line_number + CONTEXT_LINES)

      File.readlines(filename).each.with_index do |line, line_index|
        current_line_number = line_index + 1

        if line_numbers_before.include?(current_line_number) ||
           line_numbers_after.include?(current_line_number)
          print_file_line(current_line_number, line)
        elsif current_line_number == line_number
          print_file_line(current_line_number, Rainbow(line.chomp).red)
        end
      end
    end

    def self.get_error_location(error, source_location)
      error_location = error.backtrace.detect do |entry|
        entry.start_with?(source_location) || entry.match?(/kitchen\/lib\/kitchen\/directions/)
      end

      error_filename, error_line_number = error_location.match(/(.*):(\d+):/)[1..2]
      [error_line_number.to_i, error_filename]
    end

    def self.print_file_line(line_number, line)
      puts "#{format('%5s', line_number)}| #{line}"
    end

    def self.print_specific_help_line(error)
      # No specific help lines at the moment, an example is shown for the future

      # help_line = case error.message
      # when /some string in error/
      #   "`foo` needs to be called on a Bar object"
      # else
      #   nil
      # end

      # if !help_line.nil?
      #   puts help_line
      #   puts "\n"
      # end
    end
  end
end
