require 'spree_core'
require 'whp_default_addresses_hooks'

module WhpDefaultAddresses
  class Engine < Rails::Engine

    config.autoload_paths += [config.root+"/lib"]

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      Address.class_eval do
        belongs_to :user
        has_many :shipments

        has_many :orders, :foreign_key => "bill_address_id"
        # can modify an address if it's not been used in an order (but checkouts controller has finer control)
        def editable?
          new_record? || (shipments.empty? && orders.empty?)
        end

        # can modify an address if it's not been used in an order (but checkouts controller has finer control)
        def self.default(user = nil)
          new(:country => Country.find(Spree::Config[:default_country_id]), :user => user)
        end

        def zone
          (state && state.zone) ||
            (country && country.zone)
        end

        def zones
          Zone.match(self)
        end

        def same_as?(other)
          attributes.except("id", "updated_at", "created_at") ==  other.attributes.except("id", "updated_at", "created_at")
        end
        alias same_as same_as?

        def clone
          editable? ? self : super
        end

        def to_s
          "#{full_name}: #{address1}"
        end
      end

      User.class_eval do
        has_many :addresses

        belongs_to :ship_address, :class_name => "Address", :foreign_key => "ship_address_id"
        belongs_to :bill_address, :class_name => "Address", :foreign_key => "bill_address_id"

        # prevents a user from submitting a crafted form that bypasses activation
        # anything else you want your user to change should be added here.
        attr_accessible :email, :password, :password_confirmation, :ship_address_id, :bill_address_id
      end

      OrderTransactionObserver.instance
    end


    config.to_prepare &method(:activate).to_proc
  end
end
