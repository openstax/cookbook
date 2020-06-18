module Kitchen
  class ElementEnumerator < Enumerator

    def cut
      clipboard = Clipboard.new
      self.each do |element|
        element.cut(to: clipboard)
      end
      clipboard
    end

  end
end
