# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

require 'rails_helper'

RSpec.describe Issue1219ZhtwLocaleTypo, db_adapter: :postgresql, type: :db_migration do
  # Test code does not apply properly on mysql which is fading away - so run it only on postgresql.
  let(:locale)      { create(:locale, locale: premigrate_locale, name: 'Chinese (Trad.) (繁體中文)') }
  let(:translation) { create(:translation, locale: premigrate_locale) }
  let(:user)        { create(:user, preferences: { locale: premigrate_locale }) }

  before do
    Locale.where(locale: %w[zh-tw zj-tw]).each(&:destroy)
    stub_const("#{described_class}::CURRENT_VERSION", version)
  end

  context 'upgrading to version 2.5.0+' do
    let(:premigrate_locale) { 'zj-tw' }
    let(:version) { Gem::Version.new('2.5.0') }

    it 'corrects the zh-tw locale code' do
      expect { migrate }
        .to change { locale.reload.locale }
        .from('zj-tw').to('zh-tw')
    end

    it 'updates translation records' do
      expect { migrate }
        .to change { translation.reload.locale }
        .from('zj-tw').to('zh-tw')
    end

    it 'updates user records (preferences[:locale])' do
      expect { migrate }
        .to change { user.reload.preferences[:locale] }
        .from('zj-tw').to('zh-tw')
    end
  end

  context 'downgrading to version <2.5.0' do
    let(:premigrate_locale) { 'zh-tw' }
    let(:version) { Gem::Version.new('2.4.99') }

    it 'reverts the zh-tw locale code back to zj-tw' do
      expect { migrate(:down) }
        .to change { locale.reload.locale }
        .from('zh-tw').to('zj-tw')
    end

    it 'reverts translation records' do
      expect { migrate(:down) }
        .to change { translation.reload.locale }
        .from('zh-tw').to('zj-tw')
    end

    it 'reverts user records (preferences[:locale])' do
      expect { migrate(:down) }
        .to change { user.reload.preferences[:locale] }
        .from('zh-tw').to('zj-tw')
    end
  end
end
