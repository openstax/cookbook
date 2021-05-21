# frozen_string_literal: true

# rubocop:disable Style/Documentation

# Make debug output more useful (dumping entire document out is not useful)
module Nokogiri
  module XML
    # rubocop:disable Style/MutableConstant
    PROFILE_DATA = {}
    # rubocop:enable Style/MutableConstant

    if ENV['PROFILE']
      # Patches inside Nokogiri to count, time, and print searches.  At end of baking
      # you can `puts Nokogiri::XML::PROFILE_DATA` to see the totals.  The counts
      # hash is defined outside of the if block so that code that prints it doesn't
      # explode if run without the env var.  The `print_profile_data` method is also
      # provided for a nice printout

      def self.print_profile_data
        total_duration = 0

        sorted_profile_data = PROFILE_DATA.sort_by { |_, data| data[:time] / data[:count] }.reverse

        puts "\nSearch Profile Data"
        puts '-----------------------------------------------------------------'
        puts "#{'Total Time (ms)'.ljust(17)}#{'Avg Time (ms)'.ljust(15)}#{'Count'.ljust(7)}Query"
        puts '-----------------------------------------------------------------'

        sorted_profile_data.each do |search_path, data|
          total_time = format('%0.4f', (data[:time] * 1000))
          avg_time = format('%0.4f', ((data[:time] / data[:count]) * 1000))
          puts total_time.ljust(17) + avg_time.to_s.ljust(15) + data[:count].to_s.ljust(7) + \
               search_path
          total_duration += data[:time] * 1000
        end

        puts "\nTotal time across all searches (ms): #{total_duration}"
      end

      class XPathContext
        alias_method :original_evaluate, :evaluate
        def evaluate(search_path, handler=nil)
          puts search_path

          PROFILE_DATA[search_path] ||= Hash.new(0)
          PROFILE_DATA[search_path][:count] += 1

          start_time = Time.now
          original_evaluate(search_path, handler).tap do
            PROFILE_DATA[search_path][:time] += Time.now - start_time
          end
        end
      end
    end
  end
end

# rubocop:enable Style/Documentation
