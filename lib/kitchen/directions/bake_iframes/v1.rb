# frozen_string_literal: true

module Kitchen::Directions::BakeIframes
  class V1
    def bake(outer_element:)
      iframes = outer_element.search('iframe')
      return unless iframes.any?

      iframes.each do |iframe|
        next if iframe.has_class?('os-is-iframe')

        iframe.wrap('<div class="os-has-iframe" data-type="alternatives">')
        iframe.add_class('os-is-iframe')
        link_ref = iframe[:src]
        next unless link_ref

        iframe = iframe.parent
        iframe.add_class('os-has-link')
        iframe.prepend(child:
          <<~HTML
            <a class="os-is-link" href="#{link_ref}" target="_window">#{I18n.t(:iframe_link_text)}</a>
          HTML
        )
      end
    end
  end
end
