# frozen_string_literal: true

module Kitchen
  # A class to track and modify duplicate IDs in a document
  #
  class IdTracker

    def initialize
      @id_data = Hash.new { |hash, key| hash[key] = { count: 0, last_pasted: false } }
      @id_copy_suffix = '_copy_'
    end

    # Keeps track that an element with the given ID has been copied.  When such
    # elements are pasted, this information is used to give those elements unique
    # IDs that don't duplicate the original element.
    #
    # @param id [String] the ID
    #
    def record_id_copied(id)
      return if id.blank?

      @id_data[id][:count] += 1
      @id_data[id][:last_pasted] = false
    end

    # Keeps track that an element with the given ID has been cut.
    #
    # @param id [String]
    #
    def record_id_cut(id)
      return if id.blank?

      @id_data[id][:count] -= 1 if @id_data[id][:count].positive?
      @id_data[id][:last_pasted] = false
    end

    # Keeps track that an element with the given ID has been pasted.
    #
    # @param id [String]
    #
    def record_id_pasted(id)
      return if id.blank?

      @id_data[id][:count] += 1 if @id_data[id][:last_pasted]
      @id_data[id][:last_pasted] = true
    end

    def first_id?(id)
      return nil if id.nil?

      @id_data[id][:count].zero?
    end
  end
end
