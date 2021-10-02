require_relative 'Property'
require 'json'

class PropertyList
    attr_accessor :array

    def initialize
        @array = convert_to_property
    end

    def convert_to_property
        json = JSON.load_file('./data/properties.json', symbolize_names: true)
        properties = []
        json.each {|prop| 
            new_property = Property.new(prop[:type], prop[:weekly_rent], prop[:landlord], prop[:tenant], prop[:address], prop[:status])
            properties.push(new_property)
        }
        return properties
    end

    def create_property(type, rent, status, address, landlord, tenant)
        new_property = @array.push(Property.new(type, rent, landlord, tenant, address, status))
        save_list()
    end

    def update_tenant(property_id, tenant_firstname, tenant_lastname)
        @array.each do |property|
            if property.property_id == property_id
                if property.tenant.first_name && property.tenant.last_name
                    property.tenant.first_name = tenant_firstname
                    property.tenant.last_name = tenant_lastname
                else
                    property.tenant.first_name = tenant_firstname
                    property.tenant.last_name = tenant_lastname
                    property.status = 'Occupied'
                end
            end
        end
        save_list()
    end

    def update_landlord(property_id, landlord_firstname, tenant_last_name)
        @array.each do |property|
            if property.property_id == property_id
                property.landlord.first_name = landlord_firstname
                property.landlord.last_name = tenant_last_name
            end
        end
        save_list()
    end
    
    def update_status(property_id, status)
        selected_property = @array.find { |property| property.property_id == property_id}
        selected_property&.update_status(status) 
    end

    def update_rent(property_id, weekly_rent)
        selected_property = @array.find {|property| property.property_id == property_id}
        selected_property&.update_rent(weekly_rent)
    end

    def remove_property(property_id)
        @array.delete_if {|property| property.property_id == property_id}
        save_list()
    end

    def property_options
        return @array.map {|property|
            {
                name: property.print_list,
                value: property.property_id
            }
        }
    end

    def save_list
        jsonArray = @array.map { |property| 
            {
            "property_id": property.property_id,
            "type": property.type,
            "address": {
                "street_number": property.address[:street_number],
                "street_name": property.address[:street_name],
                "suburb": property.address[:suburb]
                },
            "weekly_rent": property.rent,
            "status": property.status,
            "landlord": {
                "first_name": property.landlord.first_name,
                "last_name": property.landlord.last_name
                },
            "tenant": {
                "first_name": property.tenant.first_name,
                "last_name": property.tenant.last_name
                }
            }
        }
       
        File.write('./data/properties.json', JSON.pretty_generate(jsonArray))
    end
end
