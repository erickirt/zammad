# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

User.create_if_not_exists(
  id:            1,
  login:         '-',
  firstname:     '-',
  lastname:      '',
  email:         '',
  active:        false,
  updated_by_id: 1,
  created_by_id: 1
)

UserInfo.current_user_id = 1
