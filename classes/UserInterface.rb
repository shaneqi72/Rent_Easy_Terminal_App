require 'tty-font'
require 'pastel'
require 'tty-prompt'
require 'tty-table'
require_relative '../classes/PropertyList'
require_relative '../classes/UserInterface'
require 'json'

class UserInterface

    attr_accessor :property_full_list, :property_list

    def initialize
        @property_full_list = []
        @property_list = PropertyList.new
    end
    
    def main_menu()
        prompt = TTY::Prompt.new
        user = prompt.ask("What is your name?")
        puts "Welcome #{user}"

        options = {
            "Print my property portfolio list": 1,
            "Create a new leasing property": 2,
            "Update existing property": 3,
            "Exit": 4
        }
        menuLoop = true

        while menuLoop == true
            user_selection = prompt.select("Please select one of the following action: ", options)

            case user_selection
            
            when 1
                print_full_list()

            when 2
                create_new_property()
            when 3
                update_exist_property()
            when 4
               return menuLoop = false

            end
        end
    end

    def print_full_list
        @property_full_list  = JSON.load_file('./data/properties.json', symbolize_names: true)
        headers  = ["Type", "Address", "Weekly rent", "Status", "Landlord", "Tenant"]
        list = []
        @property_full_list.each do |property|
            list.push([property[:type], "#{property[:address][:street_number]} #{property[:address][:street_name]}, #{property[:address][:suburb]}", property[:weekly_rent], property[:status], "#{property[:landlord][:first_name]} #{property[:landlord][:last_name]}", "#{property[:tenant][:first_name]} #{property[:tenant][:last_name]}"])
          
        end

        table = TTY::Table.new(headers, list)

        puts table.render(:ascii)

    end

    def create_new_property
        prompt = TTY::Prompt.new
        type = prompt.select("Choose the property type?", %w(Unit House Townhouse))
        weekly_rent = prompt.ask("What is the weekly rent? (start with $ and follow by number)",required: true)
        property_status = prompt.select("Please select the current property status?", %w(Occupied Vacant))
        if property_status == 'Occupied'
            tenant_first_name = prompt.ask("What is the current tenant first name?", required: true)
            tenant_last_name = prompt.ask("What is the current tenant last name?", required: true)
        end
        street_number = prompt.ask("What is the street number?", required: true)
        street_name = prompt.ask("What is the street name?", required: true)
        suburb = prompt.ask("What is the suburb?", required: true)
        landlord_firstname = prompt.ask("What is the landlord firstname", required: true)
        landlord_lastname = prompt.ask("What is the landlord lastname", required: true)

        @property_list.create_property(type, weekly_rent, property_status, street_number, street_name, suburb, landlord_firstname, landlord_lastname, tenant_first_name, tenant_last_name)
    end

    def update_exist_property
        prompt = TTY::Prompt.new
        options = @property_list.property_options
        choice = prompt.select("What property to update", options)
    end
end

