# frozen_string_literal: true

module Kitchen::Directions::BakeIframes
  class V1
    def bake(book:)
      iframes = book.search_with(Kitchen::PageElementEnumerator, \
                                 Kitchen::CompositePageElementEnumerator).search('iframe')
      return unless iframes.any?

      iframes.each do |iframe|
        next if iframe.has_class?('os-is-iframe') # don't double-bake

        iframe_link = '/404-this-link-should-be-replaced'

        iframe.wrap('<div class="os-has-iframe" data-type="switch">')
        iframe.add_class('os-is-iframe')

        iframe = iframe.parent
        iframe.add_class('os-has-link')

        iframe.prepend(child:
          <<~HTML
            <a class="os-is-link" data-needs-rex-link="true" href="#{iframe_link}" target="_blank" rel="noopener nofollow">#{I18n.t(:iframe_link_text)}</a>
          HTML
        )

        iframe.first('a.os-is-link').add_platform_media('print')
        iframe.first('iframe').add_platform_media('screen')
      end
    end
  end
end
