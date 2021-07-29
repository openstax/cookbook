# frozen_string_literal: true

module Kitchen::Directions::BakeHandbook
  class V1
    def bake(book:, title_element:)
      book.pages('$.handbook').each do |page|
        page.titles.each do |title|
          title.replace_children(with:
            <<~HTML
              <span data-type="" itemprop="" class="os-text">#{title.text}</span>
            HTML
          )
          title.name = title_element
        end

        # Create Outline Title
        outline_html = <<~HTML
          <div class="os-handbook-outline">
            <h3 class="os-title">#{I18n.t(:handbook_outline_title)}</h3>
          </div>
        HTML
        page.title.append(sibling: outline_html)

        bake_first_section_title_and_objectives(page: page)
        fix_nested_section_headers(page: page)
      end
    end

    # Bake Handbook First Section Title
    def bake_first_section_title_and_objectives(page:)
      outline_items_html = []
      page.search('> section').each do |section|
        first_section_title = section.titles.first
        first_section_title.replace_children(with:
          <<~HTML
            <span class="os-part-text">H</span>
            <span class="os-number">#{section.count_in(:page)}</span>
            <span class="os-divider">. </span>
            <span class="os-text">#{first_section_title.text}</span>
          HTML
        )
        first_section_title.name = 'h2'

        outline_item_html = <<~HTML
          <div class="os-handbook-objective">
            <a class="os-handbook-objective" href="##{first_section_title[:id]}">
              #{first_section_title.children}
            </a>
          </div>
        HTML
        outline_items_html.push(outline_item_html)
      end
      page.search('.os-handbook-outline').first.append(child:
        <<~HTML
          #{outline_items_html.join}
        HTML
      )
    end

    def fix_nested_section_headers(page:)
      page.search('section').each do |section|
        section_data_depth = section[:'data-depth']
        case section_data_depth
        when '2'
          section.titles.first.name = 'h3'
        when '3'
          section.titles.first.name = 'h4'
        when '4'
          section.titles.first.name = 'h5'
        end
      end
    end
  end
end
