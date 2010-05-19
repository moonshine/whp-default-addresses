class Admin::AddressesController < Admin::BaseController
  resource_controller
  belongs_to :user
  actions :index, :update

  include DefaultAddresses
end