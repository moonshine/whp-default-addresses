class AddressesController < Spree::BaseController
  resource_controller
  belongs_to :user
  actions :index, :update

  # Include helper to that we can use field_container helper which
  # is an admin helper
  helper 'admin/base'

  # Include shared code
  include DefaultAddresses
end