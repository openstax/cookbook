# frozen_string_literal: true

module StubHelpers
  def stub_locales(hash)
    I18n.config.available_locales = %i[test en pl]
    allow_any_instance_of(I18n::Config).to receive(:backend).and_return(
      I18n::Backend::Simple.new.tap do |backend|
        backend.store_translations 'test', hash.merge(Kitchen::TRANSLITERATIONS)
      end
    )
    allow_any_instance_of(I18n::Config).to receive(:locale).and_return(:test)
  end
end
