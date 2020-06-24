module Kitchen
  class NoteElement < Element

    def self.short_type
      :note
    end

    # TODO allow specifying element or node and document
    def initialize(element:)
      super(node: element.raw, document: element.document, short_type: self.class.short_type)
    end

    def title
      block_error_if(block_given?)
      first("[data-type='title']")
    end

    protected

    # TODO pass enumerator class to Element constructor and get rid of this in each element
    def as_enumerator
      NoteElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
