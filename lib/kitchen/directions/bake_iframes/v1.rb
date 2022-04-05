# frozen_string_literal: true

module Kitchen::Directions::BakeIframes
  class V1
    def bake(book:)
      iframes = book.search('iframe')
      return unless iframes.any?

      iframes.each do |iframe|
        next if iframe.has_class?('os-is-iframe')

        iframe.wrap('<div class="os-has-iframe" data-type="alternatives">')
        iframe.add_class('os-is-iframe')
        link_ref = iframe[:src]
        next unless link_ref

        resource_link = link_ref.match(/..\/resources\/.*\/index.html/)
        next if resource_link # TODO: behavior for resource links

        iframe = iframe.parent
        iframe.add_class('os-has-link')

        iframe.prepend(child:
          <<~HTML
            <a class="os-is-link" href="#{link_ref}" target="_blank" rel="noopener nofollow">#{I18n.t(:iframe_link_text)}</a>
          HTML
        )
      end
    end
  end
end
