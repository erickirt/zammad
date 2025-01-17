# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

module Sequencer::Unit::Import::Common::Model::Mixin::Skip::Action

  module ClassMethods

    def skip_action(*actions)
      declaration_accessor(
        key:        __method__,
        attributes: actions
      )
    end
    alias skip_actions skip_action

    def skip_any_action
      skip_actions(:any)
    end

    def skip_action?(action)
      logger.debug { "Checking if skip is necessary for action #{action.inspect}." }
      return false if action.blank?

      logger.debug { "Checking if skip is necessary for skip_actions #{skip_actions.inspect}." }
      return false if skip_actions.blank?
      return true if skip_actions.include?(action)
      return true if skip_actions.include?(:any)

      false
    end
  end

  def self.prepended(base)
    base.optional :action
    base.extend(ClassMethods)
  end

  def process
    if self.class.skip_action?(action)
      logger.debug { "Skipping due to provided action #{action.inspect}." }
    else
      logger.debug { "Nope. Won't skip action #{action.inspect}." }
      super
    end
  end
end
