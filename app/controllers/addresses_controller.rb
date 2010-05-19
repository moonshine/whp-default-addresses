class AddressesController < Spree::BaseController
  resource_controller
  belongs_to :user
  actions :index, :update

  helper 'admin/base'
  
  include DefaultAddresses
end