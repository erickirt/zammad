# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

class Channel::Filter::ServiceNowCheck < Channel::Filter::BaseExternalCheck
  MAIL_HEADER        = 'x-servicenow-generated'.freeze
  SOURCE_ID_REGEX    = %r{\s(INC\d+)\s}
  SOURCE_NAME_PREFIX = 'ServiceNow'.freeze
end
