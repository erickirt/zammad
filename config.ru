# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

# This file is used by Rack-based servers to start the application.

require File.expand_path('config/environment', __dir__)
run Zammad::Application

# set config to do no self notification
Rails.configuration.webserver_is_active = true
