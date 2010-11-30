class WhpDefaultAddressesHooks < Spree::ThemeSupport::HookListener
  # Add link to edit addresses to my account page
  replace :account_summary, 'users/default_addresses'

  # Add link to edit addresses to user records
  insert_after :admin_users_index_row_actions do
    '&nbsp;<%=link_to(t(:edit_addresses), admin_user_addresses_path(user)) %>'
  end

end