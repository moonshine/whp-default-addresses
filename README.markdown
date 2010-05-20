= Default Addresses

Extension provides a way to have default addresses assigned to user.
His addresses will be filled by with these defaults on checkout.

========================================

You can import most recent addresses and set them as defaults by running
rake get_default_addresses

========================================

For spree 0.8.3  you have to replace 2 lines in lib/spree/checkout.rb.

14,15c14,15
<     @order.bill_address ||= Address.new(:country => @default_country)
<     @order.ship_address ||= Address.new(:country => @default_country)
---
>     @order.bill_address ||= (current_user && current_user.bill_address.clone) || Address.default(current_user)
>     @order.ship_address ||= (current_user && current_user.ship_address.clone) || Address.default(current_user)

= Whyte House Default Addresses

We decided to create a new project as there have been a large number of code
changes from the original.

The whp version is based on the spree-default-addresses extension but has 
a new admin form that does not redirect to the user form.

= ToDo

- Update the tests
- Figure out of way to highlight the "Users" tab when going to the addresses
  edit form in admin.