require_relative 'Property'
require 'json'
class PropertyList
    attr_reader :array
    def initialize
        # array of property classes
        @array = convert_to_property
    end

    # def assign_array(newArray)
    #     @array = newArray
    # end

    def convert_to_property
        json = JSON.load_file('./data/properties.json', symbolize_names: true)
        properties = []
        json.each {|prop| 
            new_property = Property.new(prop[:type], prop[:rent], prop[:status])
            new_property.create_landlord(prop[:landlord_firstname], prop[:landlord_lastname])
            new_property.create_address(prop[:address][:street_number], prop[:address][:street_name], prop[:address][:suburb])
            new_property.update_tenant(prop[:tenant_first_name], prop[:tenant_last_name])
            properties.push(new_property)
        }
        return properties
    end

    def create_property(type, rent, status, street_number, street_name, suburb, landlord_firstname, landlord_lastname, tenant_first_name= null, tenant_last_name= null)
        new_property = Property.new(type, rent, status)
        new_property.create_landlord(landlord_firstname, landlord_lastname)
        new_property.create_address(street_number, street_name, suburb)
        new_property.update_tenant(tenant_first_name, tenant_last_name)
        @array.push(new_property)
        save_list()
    end

    def update_tenant(property_id, tenant_first_name, tenant_last_name)
        selected_property = @array.find { |property| property.property_id == property_id}
        selected_property.update_tenant(tenant_first_name, tenant_last_name) if selected_property
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
        selected_property = @array.find { |property| property.property_id == property_id}
        selected_property & @array.delete_if { |property| property.property_id == property_id}
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

        # jsonArray.to_json


        # parsed = JSON.load_file('./data/properties.json', symbolize_names: true)
       
        File.write('./data/properties.json', JSON.pretty_generate(jsonArray))
    end
end
