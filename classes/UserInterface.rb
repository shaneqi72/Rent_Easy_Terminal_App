require 'tty-font'
require 'pastel'
require 'tty-prompt'
require 'tty-table'
require_relative '../classes/PropertyList'
require_relative '../classes/UserInterface'
require 'json'
require 'rainbow'




class UserInterface
   
    attr_accessor :property_full_list, :property_list

    def initialize
        @property_list = PropertyList.new
    end
    
    def main_menu()
        prompt = TTY::Prompt.new
        user = prompt.ask("What is your name?")
        puts Rainbow("Welcome #{user}").yellow

        main_menu_options = {
            "Print my property portfolio list": 1,
            "Create a new leasing property": 2,
            "Update existing property": 3,
            "Remove property": 4,
            "Exit": 5
        }

        print_menu_options = {
            "All Properties List": 1,
            "Vacant Properties List": 2,
            "Occupied Properties List": 3
        }

        menuLoop = true
        while menuLoop == true
             pastel = Pastel.new
            user_selection = prompt.select("Please select one of the following action: ", main_menu_options)

            case user_selection
            when 1
                print_selection = prompt.select("Which list do you want to print?", print_menu_options)
                case print_selection
                when 1
                   print_full_list(1) 
                when 2
                    print_full_list(2)
                when 3
                    print_full_list(3)
                end
            when 2
                create_new_property()
            when 3
                update_exist_property()
            when 4
                remove_property()
            when 5
               return menuLoop = false

            end
        end
    end

    def print_full_list(list_selection)
        headers  = ["Type", "Address", "Weekly rent", "Status", "Landlord", "Tenant"]
        full_list = []
        vacant_list = []
        occupied_list = []
        @property_list.array.each do |property|
            full_list.push([property.type, "#{property.address[:street_number]} #{property.address[:street_name]}, #{property.address[:suburb]}", property.rent, property.status, "#{property.landlord.first_name} #{property.landlord.last_name}", "#{property.tenant.first_name} #{property.tenant.last_name}"])

            vacant_list.push([property.type, "#{property.address[:street_number]} #{property.address[:street_name]}, #{property.address[:suburb]}", property.rent, property.status, "#{property.landlord.first_name} #{property.landlord.last_name}", "#{property.tenant.first_name} #{property.tenant.last_name}"]) if property.status == "Vacant"
            
            occupied_list.push([property.type, "#{property.address[:street_number]} #{property.address[:street_name]}, #{property.address[:suburb]}", property.rent, property.status, "#{property.landlord.first_name} #{property.landlord.last_name}", "#{property.tenant.first_name} #{property.tenant.last_name}"]) if property.status == "Occupied"
        end
        case list_selection
        when 1
            table = TTY::Table.new(headers, full_list)
            puts "There is no property in list yet" if full_list.length < 1
        when 2
            table = TTY::Table.new(headers, vacant_list)
            puts "The vacant list is empty!" if vacant_list.length < 1 
        when 3
            table = TTY::Table.new(headers, occupied_list)
            puts "The occupied list is empty!" if occupied_list.length < 1
        end
        puts table.render(:ascii)

    end

    def create_new_property
        prompt = TTY::Prompt.new
        type = prompt.select("Choose the property type?", %w(Unit House Townhouse))
        street_number = prompt.ask("What is the street number?", required: true)
        street_name = prompt.ask("What is the street name?", required: true)
        suburb = prompt.ask("What is the suburb?", required: true)
        weekly_rent = prompt.ask("What is the weekly rent? (start with $ and follow by number)", required: true)
        property_status = prompt.select("Please select the current property status?", %w(Occupied Vacant))
        if property_status == 'Occupied'
            tenant_first_name = prompt.ask("What is the current tenant first name?", required: true)
            tenant_last_name = prompt.ask("What is the current tenant last name?", required: true)
        end
        landlord_firstname = prompt.ask("What is the landlord firstname", required: true)
        landlord_lastname = prompt.ask("What is the landlord lastname", required: true)

        # @property_list.create_property(type, weekly_rent, property_status, street_number, street_name, suburb, landlord_firstname, landlord_lastname, tenant_first_name, tenant_last_name)
        @property_list.create_property(type, weekly_rent, property_status, {street_number: street_number, street_name: street_name, suburb: suburb}, {first_name: landlord_firstname, last_name: landlord_lastname}, {first_name: tenant_first_name, last_name: tenant_last_name})
    end

    def update_exist_property
        return puts "Your portfolio is empty" if @property_list.array.length < 1 
        prompt = TTY::Prompt.new
        options = @property_list.property_options
        choice = prompt.select("What property to update", options)
        fields = {
            "Weekly Rent": 1,
            "Tenant Name": 2,
            "Landlord Name": 3
        }
        field = prompt.select("Which filed", fields)

        # selected_property = @property_list.array.select {|property| property.property_id == choice}

        case field
            when 1
                updated_rent = prompt.ask("what's new rent")
                @property_list.array.each do |property|
                property.rent = updated_rent if property.property_id == choice
                end
            when 2 
                first_name = prompt.ask("Tenant firstname?")
                last_name = prompt.ask("Tenant lastname")
                @property_list.update_tenant(choice, first_name, last_name)
            when 3
                first_name = prompt.ask("Landlord firstname?")
                last_name = prompt.ask("Landlord lastname")
                @property_list.update_landlord(choice, first_name, last_name)
        end
    end

    def remove_property
        return puts "Your portfolio is empty" if @property_list.array.length < 1 
        prompt = TTY::Prompt.new
        options = @property_list.property_options
        choice = prompt.select("Which property to be deleted", options)
        @property_list.remove_property(choice)
    end
end

