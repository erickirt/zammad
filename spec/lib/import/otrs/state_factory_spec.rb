# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

require 'rails_helper'
require 'lib/import/transaction_factory_examples'

RSpec.describe Import::OTRS::StateFactory do
  let(:state_backend_param) do
    states = %w[new open merged pending_reminder pending_auto_close_p pending_auto_close_n pending_auto_close_p closed_successful closed_unsuccessful removed]

    states.map do |state|
      load_state_json(state)
    end
  end

  it_behaves_like 'Import::TransactionFactory'

  it 'creates a state backup in the pre_import_hook' do
    expect(described_class).to receive(:backup)
    described_class.pre_import_hook([])
  end

  def load_state_json(file)
    json_fixture("import/otrs/state/#{file}")
  end

  it 'updates ObjectManager Ticket state_id and pending_time filter' do
    ticket_state_id = ObjectManager::Attribute.get(
      object: 'Ticket',
      name:   'state_id',
    )
    ticket_pending_time = ObjectManager::Attribute.get(
      object: 'Ticket',
      name:   'pending_time',
    )

    expect do
      described_class.import(state_backend_param)

      # sync changes
      ticket_state_id.reload
      ticket_pending_time.reload
    end.to change {
      ticket_state_id.data_option
    }.and change {
      ticket_state_id.screens
    }
  end

  it "doesn't update ObjectManager Ticket state_id and pending_time filter in diff import" do

    ticket_state_id = ObjectManager::Attribute.get(
      object: 'Ticket',
      name:   'state_id',
    )
    ticket_pending_time = ObjectManager::Attribute.get(
      object: 'Ticket',
      name:   'pending_time',
    )

    allow(Import::OTRS).to receive(:diff?).and_return(true)

    expect do
      described_class.update_attribute_settings

      # sync changes
      ticket_state_id.reload
      ticket_pending_time.reload
    end.to not_change {
      ticket_state_id.data_option
    }.and not_change {
      ticket_state_id.screens
    }.and not_change {
      ticket_pending_time.data_option
    }
  end

  it 'sets default create and update State' do
    state                   = Ticket::State.first
    state.default_create    = false
    state.default_follow_up = false
    state.callback_loop     = true
    state.save

    allow(Import::OTRS::SysConfigFactory).to receive(:postmaster_default_lookup).with(:state_default_create).and_return(state.name)
    allow(Import::OTRS::SysConfigFactory).to receive(:postmaster_default_lookup).with(:state_default_follow_up).and_return(state.name)

    described_class.update_attribute
    state.reload

    expect(state.default_create).to be true
    expect(state.default_follow_up).to be true
  end

  it "doesn't set default create and update State in diff import" do
    state                   = Ticket::State.first
    state.default_create    = false
    state.default_follow_up = false
    state.callback_loop     = true
    state.save

    allow(Import::OTRS).to receive(:diff?).and_return(true)

    described_class.update_attribute_settings
    state.reload

    expect(state.default_create).to be false
    expect(state.default_follow_up).to be false
  end

  it 'sets next state for pending auto states' do
    described_class.import(state_backend_param)

    state_pending_auto_close_n = Ticket::State.find_by(name: 'pending auto close-')
    state_pending_auto_close_p = Ticket::State.find_by(name: 'pending auto close+')

    expect(state_pending_auto_close_n.next_state_id).to eq(Ticket::State.find_by(name: 'closed unsuccessful').id)
    expect(state_pending_auto_close_p.next_state_id).to eq(Ticket::State.find_by(name: 'closed successful').id)
  end

  context 'when some default otrs states not exists' do
    let(:state_backend_param) do
      states = %w[new open merged pending_reminder pending_auto_close_p pending_auto_close_n pending_auto_close_p removed closed_other]

      states.map do |state|
        load_state_json(state)
      end
    end

    it 'use fallback for next state for pending auto states' do
      described_class.import(state_backend_param)

      state_pending_auto_close_n = Ticket::State.find_by(name: 'pending auto close-')
      state_pending_auto_close_p = Ticket::State.find_by(name: 'pending auto close+')

      expect(state_pending_auto_close_n.next_state_id).to eq(Ticket::State.find_by(name: 'closed other').id)
      expect(state_pending_auto_close_p.next_state_id).to eq(Ticket::State.find_by(name: 'closed other').id)
    end
  end

  context 'changing Ticket::State IDs' do
    it 'updates Overviews' do
      name     = 'My Pending Reached Tickets'
      overview = Overview.find_by(name: name)
      expect do
        described_class.import(state_backend_param)
        overview = Overview.find_by(name: name)
      end.to change {
        overview.id
      }.and change {
        overview.condition['ticket.state_id'][:value]
      }
    end

    it 'updates Macros' do
      name  = 'Close & Tag as Spam'
      macro = Macro.find_by(name: name)
      expect do
        described_class.import(state_backend_param)
        macro = Macro.find_by(name: name)
      end.to change {
        macro.id
      }.and change {
        macro.perform['ticket.state_id'][:value]
      }
    end

    it 'updates Triggers' do
      name    = 'auto reply (on new tickets)'
      trigger = Trigger.find_by(name: name)
      expect do
        described_class.import(state_backend_param)
        trigger = Trigger.find_by(name: name)
      end.to change {
        trigger.id
      }.and change {
        trigger.condition['ticket.state_id'][:value]
      }
    end
  end
end
