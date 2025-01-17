# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

require_dependency 'tasks/zammad/command.rb'

module Tasks
  module Zammad
    module Package
      class List < Tasks::Zammad::Command

        def self.description
          'List all installed Zammad addon packages'
        end

        def self.task_handler
          ::Package.all.each do |package|
            puts package.name.ljust(20) + package.vendor.ljust(20) + package.version
          end
        end

      end
    end
  end
end
