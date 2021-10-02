require_relative 'Landlord'
require_relative 'Tenant'

require 'securerandom'

class Property
    attr_accessor :property_id, :type, :address, :rent, :status, :landlord, :tenant

    def initialize(type, rent, landlord, tenant, address, status= 'vacant')
        @property_id = SecureRandom.uuid
        @type = type
        @rent = rent
        @status = status
        @address = {
            street_number: address[:street_number],
            street_name: address[:street_name],
            suburb: address[:suburb]
        }
        @landlord = Landlord.new(landlord[:first_name], landlord[:last_name])
        @tenant = Tenant.new(tenant[:first_name], tenant[:last_name])
    end

    def update_rent(weekly_rent)
        @rent = weekly_rent
    end

    def update_status(status)
        @status = status
    end

    def print_list
        if @tenant.first_name && @tenant.last_name
            return "#{@address[:street_number]} #{@address[:street_name]}, #{@address[:suburb]}. #{@rent}/pw #{@status}. Tenant: #{@tenant.first_name} #{@tenant.last_name}. Landlord: #{@landlord.first_name} #{@landlord.last_name}"
        else 
            return "#{@address[:street_number]} #{@address[:street_name]}, #{@address[:suburb]}. #{@rent}/pw #{@status}. Tenant: Not available. Landlord: #{@landlord.first_name} #{@landlord.last_name}"
        end
    end
end
