# frozen_string_literal: true

module StubHelpers
  def stub_locales(hash)
    @locales_are_stubbed = true

    I18n.config.available_locales = %i[test en es pl]
    allow_any_instance_of(I18n::Config).to receive(:backend).and_return(
      I18n::Backend::Simple.new.tap do |backend|
        backend.store_translations 'test', hash
      end
    )

    assign_i18n_dot_locale(:test)
  end

  def with_locale(locale)
    original_locale = I18n.locale
    assign_i18n_dot_locale(locale)
    yield
  ensure
    assign_i18n_dot_locale(original_locale)
  end

  def assign_i18n_dot_locale(locale)
    if @locales_are_stubbed
      I18n.clear_string_sorter # need to do explicitly b/c not handled automatically when stubbing
      allow_any_instance_of(I18n::Config).to receive(:locale).and_return(locale)
    else
      I18n.locale = locale
    end
  end
end
