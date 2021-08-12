# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for table body
    #
    module BakeTableBody
      class V1
        renderable
        class CustomBody
          attr_reader :table
          attr_reader :klass
          attr_reader :fake_title_class
          attr_reader :fake_title
          attr_reader :to_trash

          def initialize(table:, klass:, fake_title_class: nil, fake_title: nil, to_trash: nil)
            @table = table
            @klass = klass
            @fake_title_class = fake_title_class
            @fake_title = fake_title
            @to_trash = to_trash
          end

          def modify_body(has_fake_title: false)
            @table.parent.add_class("os-#{@klass}-container")

            return unless has_fake_title

            @table.prepend(sibling:
              <<~HTML
                <div class="#{@fake_title_class}">#{@fake_title}</div>
              HTML
            )
            @to_trash.trash
          end
        end

        def bake(table:, number:)
          table.remove_attribute('summary')
          table.wrap(%(<div class="os-table">))

          table_label = "#{I18n.t(:table_label)} #{number}"
          table.pantry(name: :link_text).store table_label, label: table.id if table.id

          if table.top_titled?
            custom_table = CustomBody.new(table: table,
                                          klass: 'top-titled',
                                          fake_title_class: 'os-table-title',
                                          fake_title: table.title,
                                          to_trash: table.title_row)

            custom_table.modify_body(has_fake_title: true)
          elsif table.top_captioned?
            custom_table = CustomBody.new(table: table,
                                          klass: 'top-captioned',
                                          fake_title_class: 'os-top-caption',
                                          fake_title: table.caption_title,
                                          to_trash: table.top_caption)

            custom_table.modify_body(has_fake_title: true)
          elsif table.column_header?
            custom_table = CustomBody.new(table: table, klass: 'column-header')
            custom_table.modify_body(has_fake_title: false)
          end
        end
      end
    end
  end
end
