# This module contains common code shared by the address controllers
module DefaultAddresses

  def self.included(controller)
    controller.class_eval do
      def create
        load_collection
        before :create
        if update_addresses
          after :create
          set_flash :update
          response_for :create
        else
          after :create_fails
          set_flash :update_fails
          response_for :create_fails
        end
      end

      update.after do
        if ["bill_address", "ship_address"].include? params[:address_type]
          @user.update_attribute(params[:address_type].to_sym, @object)
        end
      end

      [update, create].each do |response|
        response.wants.html { redirect_back_or_default :action => :index }
      end

      [update.failure, create.failure].each do |response|
        response.wants.html { render :action => :index }
      end
    end
  end


  private

  def update_addresses
    @bill_address = @bill_address.clone unless @bill_address.editable?
    @ship_address = @ship_address.clone unless @ship_address.editable?

    bstatus = sstatus = nil
    Address.transaction do
      @bill_address.country = Country.find(params[:bill_address][:country_id])
      bstatus = @bill_address.update_attributes(params[:bill_address])
      # Make sure selected bill country is available as a ship to country
      # if the "Use Billing Address" option is selected
      country = Country.find(params[:bill_address][:country_id])
      if params[:ship_address] && params[:ship_address][:use_bill_address] &&
        !@shipping_countries.include?(country)
        @bill_address.errors.add_to_base t(:invalid_ship_to_country, :country => country.name)
        raise ActiveRecord::Rollback
      else
        # Check if ship same as bill address
        if params[:ship_address][:use_bill_address]
          # Delete the ship to address record if it exists
          @ship_address.destroy if (!@ship_address.id.blank? &&
            @ship_address.id != @bill_address.id &&
            Address.exists?(@ship_address.id))
          # Set the ship address equal to the bill address
          @ship_address = @bill_address.clone
          sstatus = true
        else
          # Make sure the ship address record exists, if not create one
          # otherwise update
          if @ship_address.id.blank? || @ship_address.id == @bill_address.id
            @ship_address = Address.new(params[:ship_address])
            sstatus = @ship_address.save
          else
            sstatus = @ship_address.update_attributes(params[:ship_address])
          end
        end
      end
    end

    if bstatus && sstatus
      # Update the users->addresses relationships
      @user.update_attribute(:bill_address, @bill_address)
      @user.update_attribute(:ship_address, @ship_address)
      return(true)
    else
      return(false)
    end
  end

  def collection
    @user ||= current_user

    @ship_address = @user.ship_address || Address.default(@user)
    @bill_address = @user.bill_address || Address.default(@user)

    @countries = Country.find(:all).sort
    @shipping_countries = ShippingMethod.all.collect{|method|
      method.zone.country_list
    }.flatten.uniq.sort_by{|item| item.name}
    @bill_address_states = @bill_address.country ? @bill_address.country.states.sort : []
    @ship_address_states = @ship_address.country ? @ship_address.country.states.sort : []
    @addresses = [@bill_address, @ship_address]
  end

  def object
    if params[:ship_address] && params[:ship_address][:use_bill_address]
      @object ||= @user.bill_address && @user.bill_address.clone
    else
      @object ||= @user.addresses.find_by_id(param)
    end

    @object = @object.clone if @object && !@object.editable?

    @object
  end

end
