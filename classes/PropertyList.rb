require_relative 'Property'
require 'json'

class PropertyList
    attr_accessor :array, :file_path

    def initialize(file_path)
        @file_path = file_path
        @array = convert_to_property
    end
    # convert json data into array of hashes
    def convert_to_property
        json = JSON.load_file(@file_path, symbolize_names: true)
        properties = []
        json.each {|prop| 
            new_property = Property.new(prop[:type], prop[:weekly_rent], prop[:landlord], prop[:tenant], prop[:address], prop[:status])
            properties.push(new_property)
        }
        return properties
    end

    # Create new property and save to json file
    def create_property(type, rent, status, address, landlord, tenant)
        @array.push(Property.new(type, rent, landlord, tenant, address, status))
        save_list()
    end

    # Update tenant name and update json file
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

    # Update date landlord name and update json file
    def update_landlord(property_id, landlord_firstname, landlord_last_name)
        @array.each do |property|
            if property.property_id == property_id
                property.landlord.first_name = landlord_firstname
                property.landlord.last_name = landlord_last_name
            end
        end
        save_list()
    end
    
    # Update selected property rent
    def update_rent(property_id, weekly_rent)
        @array.each do |property|
            if property.property_id == property_id
                property.rent = weekly_rent
            end
        end
        save_list()
    end

    # Remove property from json file
    def remove_property(property_id)
        @array.delete_if {|property| property.property_id == property_id}
        save_list()
    end

    # Create a array of hashed contain name and value. Value is all of property id.
    def property_options
        return @array.map {|property|
            {
                name: property.print_list,
                value: property.property_id
            }
        }
    end

    # Function to save list into json file
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
